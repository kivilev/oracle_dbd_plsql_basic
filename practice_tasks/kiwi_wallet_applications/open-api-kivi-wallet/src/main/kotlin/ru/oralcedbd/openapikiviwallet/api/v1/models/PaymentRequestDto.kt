package ru.oralcedbd.openapikiviwallet.api.v1.models

data class PaymentRequestDto(
    val fromClientId: Long,
    val toClientId: Long,
    val currencyId: Int,
    val summa: Double,
    val paymentDetail: PaymentDetailRequestDto
)