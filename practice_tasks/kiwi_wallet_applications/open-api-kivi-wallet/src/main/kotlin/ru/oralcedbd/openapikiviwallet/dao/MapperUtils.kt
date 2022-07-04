package ru.oralcedbd.openapikiviwallet.dao

import ru.oralcedbd.openapikiviwallet.dao.oratypes.TClientData
import ru.oralcedbd.openapikiviwallet.dao.oratypes.TPaymentDetail
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import java.sql.Timestamp
import java.time.ZoneId
import java.time.ZonedDateTime

object MapperUtils {
    
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