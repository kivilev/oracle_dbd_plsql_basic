package ru.oralcedbd.openapikiviwallet.model

import ru.oralcedbd.openapikiviwallet.dao.PaymentDetailFieldId
import java.time.ZonedDateTime

typealias PaymentDetail = Map<PaymentDetailFieldId, String>

data class Payment(
    val id: Long?,
    val paymentDateTime: ZonedDateTime,
    val fromClientId: Long,
    val toClientId: Long,
    val currency: Currency,
    val summa: Float,
    val status: PaymentStatus,
    val statusChangeReason: String?
) {
    constructor(
        id: Long?,
        paymentDateTime: ZonedDateTime,
        fromClientId: Long,
        toClientId: Long,
        currency: Currency,
        summa: Float,
        status: PaymentStatus,
        statusChangeReason: String?,
        paymentDetail: Map<PaymentDetailFieldId, String>
    ) : this(id, paymentDateTime, fromClientId, toClientId, currency, summa, status, statusChangeReason) {
        this.paymentDetail = paymentDetail
    }

    var paymentDetail: PaymentDetail = mapOf()
}