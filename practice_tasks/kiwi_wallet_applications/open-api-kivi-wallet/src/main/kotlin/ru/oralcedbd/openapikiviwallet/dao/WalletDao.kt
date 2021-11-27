package ru.oralcedbd.openapikiviwallet.dao

import oracle.jdbc.OracleTypes
import org.springframework.jdbc.core.SqlOutParameter
import org.springframework.jdbc.core.SqlParameter
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcCall
import org.springframework.stereotype.Repository
import ru.oralcedbd.openapikiviwallet.model.Currency
import javax.sql.DataSource

interface WalletDao {
    fun createWallet(clientId: Long): Long
    fun addAccount(clientId: Long, walletId: Long, currency: Currency, balance: Float): Long
}

@Repository
class WalletDaoImpl(private val dataSource: DataSource) : WalletDao {

    private val namedParameterJdbcTemplate: NamedParameterJdbcTemplate = NamedParameterJdbcTemplate(dataSource)
    private val createWalletFunc: SimpleJdbcCall = SimpleJdbcCall(dataSource)
    private val createAccountFunc: SimpleJdbcCall = SimpleJdbcCall(dataSource)

    init {
        createWalletFunc.withCatalogName("wallet_api_pack")
            .withFunctionName("create_wallet")
            .withoutProcedureColumnMetaDataAccess()
            .withNamedBinding()
            .declareParameters(
                SqlOutParameter("p_wallet_id", OracleTypes.BIGINT),
                SqlParameter("p_client_id", OracleTypes.NUMERIC),
            ).also(SimpleJdbcCall::compile)
        createAccountFunc.withCatalogName("account_api_pack")
            .withFunctionName("create_account")
            .withoutProcedureColumnMetaDataAccess()
            .withNamedBinding()
            .declareParameters(
                SqlOutParameter("p_account_id", OracleTypes.BIGINT),
                SqlParameter("p_wallet_id", OracleTypes.NUMERIC),
                SqlParameter("p_client_id", OracleTypes.NUMERIC),
                SqlParameter("p_currency_id", OracleTypes.NUMERIC),
                SqlParameter("p_balance", OracleTypes.NUMERIC),
            ).also(SimpleJdbcCall::compile)
    }

    override fun createWallet(clientId: Long): Long {
        val params = mapOf("p_client_id" to clientId)
        val result = createWalletFunc.execute(params)
        return result["p_wallet_id"] as Long
    }

    override fun addAccount(clientId: Long, walletId: Long, currency: Currency, balance: Float): Long {
        val params = mapOf(
            "p_client_id" to clientId,
            "p_wallet_id" to walletId,
            "p_currency_id" to currency.id,
            "p_balance" to balance
        )
        val result = createAccountFunc.execute(params)
        return result["p_account_id"] as Long
    }
}