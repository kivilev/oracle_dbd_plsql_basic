package ru.oralcedbd.openapikiviwallet.dao

import oracle.jdbc.OracleTypes
import org.springframework.data.jdbc.support.oracle.BeanPropertyStructMapper
import org.springframework.jdbc.core.SqlOutParameter
import org.springframework.jdbc.core.SqlParameter
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate
import org.springframework.jdbc.core.simple.SimpleJdbcCall
import org.springframework.stereotype.Repository
import ru.oralcedbd.openapikiviwallet.dao.MapperUtils.convertClientDataFieldMapToList
import ru.oralcedbd.openapikiviwallet.dao.oratypes.OracleSqlStructArrayValue
import ru.oralcedbd.openapikiviwallet.dao.oratypes.TClientData
import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.ClientData
import ru.oralcedbd.openapikiviwallet.utils.EnumIdValueMap
import java.sql.Types
import java.util.Optional
import javax.sql.DataSource


interface ClientDao {
    fun createClient(clientData: ClientData): Long
    fun getClient(id: Long): Optional<Client>
    fun getClientData(id: Long): ClientData
    fun changeClientData(clientId: Long, clientData: ClientData)
}

@Repository
class ClientDaoImpl(
    dataSource: DataSource,
    private val clientDataEnumIdValueMap: EnumIdValueMap<Long, ClientDataFieldId>
) : ClientDao {

    private val namedParameterJdbcTemplate: NamedParameterJdbcTemplate = NamedParameterJdbcTemplate(dataSource)
    private val createClientFunc: SimpleJdbcCall = SimpleJdbcCall(dataSource)
    private val changeClientDataProc: SimpleJdbcCall = SimpleJdbcCall(dataSource)


    init {
        createClientFunc.withCatalogName("client_api_pack")
            .withFunctionName("create_client")
            .withoutProcedureColumnMetaDataAccess()
            .withNamedBinding()
            .declareParameters(
                SqlOutParameter("client_id", Types.BIGINT),
                SqlParameter("p_client_data", OracleTypes.ARRAY, "T_CLIENT_DATA_ARRAY")
            ).also(SimpleJdbcCall::compile)

        changeClientDataProc.withCatalogName("client_data_api_pack")
            .withProcedureName("insert_or_update_client_data")
            .withoutProcedureColumnMetaDataAccess()
            .withNamedBinding()
            .declareParameters(
                SqlParameter("p_client_id", OracleTypes.NUMERIC),
                SqlParameter("p_client_data", OracleTypes.ARRAY, "T_CLIENT_DATA_ARRAY")
            ).also(SimpleJdbcCall::compile)
    }

    override fun createClient(clientData: ClientData): Long {

        val clientDataList = convertClientDataFieldMapToList(clientData)

        val params = mapOf(
            "p_client_data" to OracleSqlStructArrayValue<TClientData>(
                clientDataList.toTypedArray(),
                BeanPropertyStructMapper.newInstance(TClientData::class.java),
                "T_CLIENT_DATA",
                "T_CLIENT_DATA_ARRAY"
            )
        )
        val resultParams = createClientFunc.execute(params)
        return resultParams["client_id"] as Long
    }


    override fun getClient(id: Long): Optional<Client> {
        return Optional.ofNullable(
            namedParameterJdbcTemplate.query(
                GET_CLIENT_SQL,
                mapOf("v_client_id" to id)
            ) { rs, _ ->
                Client(
                    rs.getLong("client_id"),
                    rs.getInt("is_active"),
                    rs.getInt("is_blocked"),
                    rs.getString("blocked_reason") ?: ""
                )
            }.firstOrNull()
        )
    }

    override fun getClientData(id: Long): ClientData {
        return namedParameterJdbcTemplate.query(
            GET_CLIENT_DATA_SQL,
            mapOf("v_client_id" to id)
        ) { rs, _ ->
            Pair(
                clientDataEnumIdValueMap.toValue(rs.getLong("field_id")),
                rs.getString("field_value")
            )
        }.associateBy({ it.first }, { it.second })

    }

    override fun changeClientData(clientId: Long, clientData: ClientData) {
        val clientDataList = convertClientDataFieldMapToList(clientData)
        val params = mapOf(
            "p_client_id" to clientId,
            "p_client_data" to OracleSqlStructArrayValue<TClientData>(
                clientDataList.toTypedArray(),
                BeanPropertyStructMapper.newInstance(TClientData::class.java),
                "T_CLIENT_DATA",
                "T_CLIENT_DATA_ARRAY"
            )
        )
        changeClientDataProc.execute(params)
    }

    private companion object {
        const val GET_CLIENT_SQL = """
            select client_id, is_active, is_blocked, blocked_reason
              from client
             where client_id = :v_client_id
            """

        const val GET_CLIENT_DATA_SQL = """
           select t.field_id, t.field_value 
              from client_data t
             where t.client_id = :v_client_id            
        """
    }
}