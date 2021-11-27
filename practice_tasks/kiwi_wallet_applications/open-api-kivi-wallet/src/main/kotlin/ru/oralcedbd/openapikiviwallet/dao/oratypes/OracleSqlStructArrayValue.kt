package ru.oralcedbd.openapikiviwallet.dao.oratypes

import oracle.jdbc.OracleConnection
import org.springframework.data.jdbc.support.oracle.SqlStructArrayValue
import org.springframework.data.jdbc.support.oracle.StructMapper
import java.sql.Connection

class OracleSqlStructArrayValue<T>(
    values: Array<out T>,
    mapper: StructMapper<T>,
    structTypeName: String,
    arrayTypeName: String
) : SqlStructArrayValue<T>(values, mapper, structTypeName, arrayTypeName) {
    override fun createTypeValue(conn: Connection, sqlType: Int, typeName: String?): Any {
        return super.createTypeValue(conn.unwrap(OracleConnection::class.java), sqlType, typeName)
    }
}