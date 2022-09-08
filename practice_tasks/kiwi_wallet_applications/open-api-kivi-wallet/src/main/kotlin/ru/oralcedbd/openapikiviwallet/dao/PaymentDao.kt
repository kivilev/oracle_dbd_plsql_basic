package ru.oralcedbd.openapikiviwallet.dao

import oracle.jdbc.OracleTypes
import org.springframework.data.jdbc.support.oracle.BeanPropertyStructMapper
import org.springframework.jdbc.core.RowMapper
import org.springframework.jdbc.core.SqlOutParameter
import org.springframework.jdbc.core.SqlParameter
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcCall
import org.springframework.stereotype.Repository
import ru.oralcedbd.openapikiviwallet.dao.MapperUtils.convertDateToZonedDateTime
import ru.oralcedbd.openapikiviwallet.dao.MapperUtils.convertPaymentDetailFieldMapToList
import ru.oralcedbd.openapikiviwallet.dao.oratypes.OracleSqlStructArrayValue
import ru.oralcedbd.openapikiviwallet.dao.oratypes.TPaymentDetail
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.Payment
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import ru.oralcedbd.openapikiviwallet.utils.EnumIdValueMap
import java.sql.ResultSet
import java.sql.Types
import java.util.Optional
import javax.sql.DataSource

interface PaymentDao {
    fun createPayment(payment: Payment): Long
    fun getPayment(paymentId: Long): Optional<Payment>
    fun getPaymentDetail(paymentId: Long): Map<PaymentDetailFieldId, String>
    fun getPayments(clientId: Long): List<Payment>
}

@Repository
class PaymentDaoImpl(
    dataSource: DataSource,
    private val paymentDetailEnumIdValueMap: EnumIdValueMap<Long, PaymentDetailFieldId>,
    private val paymentStatusEnumIdValueMap: EnumIdValueMap<Int, PaymentStatus>,
    private val currencyEnumIdValueMap: EnumIdValueMap<Int, Currency>
) :
    PaymentDao {
    private val namedParameterJdbcTemplate: NamedParameterJdbcTemplate = NamedParameterJdbcTemplate(dataSource)
    private val createPaymentFunc: SimpleJdbcCall = SimpleJdbcCall(dataSource)
    private val changeClientDataProc: SimpleJdbcCall = SimpleJdbcCall(dataSource)

    init {
        createPaymentFunc.withCatalogName("payment_api_pack")
            .withFunctionName("create_payment")
            .withoutProcedureColumnMetaDataAccess()
            .withNamedBinding()
            .declareParameters(
                SqlOutParameter("payment_id", Types.BIGINT),
                SqlParameter("p_from_client_id", Types.BIGINT),
                SqlParameter("p_to_client_id", Types.BIGINT),
                SqlParameter("p_currency_id", Types.INTEGER),
                SqlParameter("p_create_dtime", Types.TIMESTAMP_WITH_TIMEZONE),
                SqlParameter("p_summa", Types.FLOAT),
                SqlParameter(
                    "p_payment_detail", OracleTypes.ARRAY, "T_PAYMENT_DETAIL_ARRAY"
                )
            ).also(SimpleJdbcCall::compile)
    }

    override fun createPayment(payment: Payment): Long {
        val paymentDetail = convertPaymentDetailFieldMapToList(payment.paymentDetail)
        val params = mapOf(
            "payment_id" to payment.id,
            "p_from_client_id" to payment.fromClientId,
            "p_to_client_id" to payment.toClientId,
            "p_currency_id" to payment.currency.id,
            "p_create_dtime" to payment.paymentDateTime,
            "p_summa" to payment.summa,
            "p_payment_detail" to OracleSqlStructArrayValue<TPaymentDetail>(
                paymentDetail.toTypedArray(),
                BeanPropertyStructMapper.newInstance(TPaymentDetail::class.java),
                "T_PAYMENT_DETAIL",
                "T_PAYMENT_DETAIL_ARRAY"
            )
        )
        val resultParams = createPaymentFunc.execute(params)
        return resultParams["payment_id"] as Long
    }

    override fun getPayment(paymentId: Long): Optional<Payment> {
        return Optional.ofNullable(
            namedParameterJdbcTemplate.query(
                GET_PAYMENT_SQL,
                mapOf("v_payment_id" to paymentId),
                paymentRowMapper
            ).firstOrNull()
        )
    }

    override fun getPaymentDetail(paymentId: Long): Map<PaymentDetailFieldId, String> {
        return namedParameterJdbcTemplate.query(
            GET_PAYMENT_DETAIL_SQL,
            mapOf("v_payment_id" to paymentId)
        ) { rs, _ ->
            Pair(
                paymentDetailEnumIdValueMap.toValue(rs.getLong("field_id")),
                rs.getString("field_value")
            )
        }.associateBy({ it.first }, { it.second })
    }

    override fun getPayments(clientId: Long): List<Payment> {
        return namedParameterJdbcTemplate.query(
            GET_ALL_PAYMENTS,
            mapOf("v_client_id" to clientId),
            paymentRowMapper
        )
    }

    private val paymentRowMapper: RowMapper<Payment> = RowMapper { rs: ResultSet, _: Int ->
        Payment(
            rs.getLong("payment_id"),
            convertDateToZonedDateTime(rs.getTimestamp("create_dtime")),
            rs.getLong("from_client_id"),
            rs.getLong("to_client_id"),
            currencyEnumIdValueMap.toValue(rs.getInt("currency_id")),
            rs.getDouble("summa"),
            paymentStatusEnumIdValueMap.toValue(rs.getInt("status")),
            rs.getString("status_change_reason")
        )
    }

    private companion object {
        const val GET_PAYMENT_SQL = """
            select payment_id,
                   create_dtime,
                   summa,
                   currency_id,
                   from_client_id,
                   to_client_id,
                   status,
                   status_change_reason
              from payment
             where payment_id = :v_payment_id
        """

        const val GET_PAYMENT_DETAIL_SQL = """
            select field_id, field_value 
              from payment_detail 
             where payment_id = :v_payment_id
        """

        const val GET_ALL_PAYMENTS = """
            select payment_id
                  ,create_dtime
                  ,summa
                  ,currency_id
                  ,status
                  ,status_change_reason
                  ,from_client_id
                  ,to_client_id
              from payment t
             where from_client_id = :v_client_id
                or to_client_id = :v_client_id
        """
    }
}