package ru.oralcedbd.openapikiviwallet.api.v1.models

import java.time.ZonedDateTime

data class PaymentResponseDto(
    val id: Long,
    val createDateTime: ZonedDateTime,
    val fromClientId: Long,
    val toClientId: Long,
    val summa: Double,
    val currencyId: Int,
    val status: Int,
    val statusChangeReason: String?,
    val paymentDetail: PaymentDetailResponseDto
)