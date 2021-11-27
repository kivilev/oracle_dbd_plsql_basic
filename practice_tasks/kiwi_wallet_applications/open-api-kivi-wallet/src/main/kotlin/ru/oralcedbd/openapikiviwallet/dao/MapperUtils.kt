package ru.oralcedbd.openapikiviwallet.dao

import ru.oralcedbd.openapikiviwallet.dao.oratypes.TClientData
import ru.oralcedbd.openapikiviwallet.dao.oratypes.TPaymentDetail
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import ru.oralcedbd.openapikiviwallet.utils.EnumIdValueMap
import java.sql.Timestamp
import java.time.ZoneId
import java.time.ZonedDateTime
import java.util.stream.Collectors

object MapperUtils {

    fun toSqlCallSerializableFields(
        fieldValues: Map<ClientDataFieldId, String>,
        fieldIdMap: EnumIdValueMap<Long, ClientDataFieldId>
    ): List<TClientData>? {
        return fieldValues.entries.stream().map { (key, value): Map.Entry<ClientDataFieldId, String> ->
            TClientData(
                fieldIdMap.toId(key),
                value
            )
        }.collect(Collectors.toList())
    }

    fun getCurrencyById(currencyId: Int): Currency {
        return Currency.values().first { it.id == currencyId }
    }

    fun getPaymentStatusById(paymentStatusId: Int): PaymentStatus {
        return PaymentStatus.values().first { it.id == paymentStatusId }
    }

    fun convertClientDataFieldMapToList(mapForConvert: Map<ClientDataFieldId, String>): List<TClientData> {
        return mapForConvert.toList().map { TClientData(it.first.id, it.second) }
    }

    fun convertPaymentDetailFieldMapToList(mapForConvert: Map<PaymentDetailFieldId, String>): List<TPaymentDetail> {
        return mapForConvert.toList().map { TPaymentDetail(it.first.id, it.second) }
    }

    fun convertDateToZonedDateTime(date: Timestamp): ZonedDateTime {
        return date.toLocalDateTime().atZone(ZoneId.systemDefault());
    }
}