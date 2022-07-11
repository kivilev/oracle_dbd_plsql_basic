package ru.oralcedbd.openapikiviwallet.api.v1.models.mapper

import org.springframework.stereotype.Component
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentDetailResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentResponseDto
import ru.oralcedbd.openapikiviwallet.dao.PaymentDetailFieldId
import ru.oralcedbd.openapikiviwallet.model.Payment
import ru.oralcedbd.openapikiviwallet.utils.MapperUtils

interface PaymentDtoMapper {
    fun mapPaymentToDto(
        payment: Payment
    ): PaymentResponseDto
}

@Component
class PaymentDtoMapperImpl : PaymentDtoMapper {

    override fun mapPaymentToDto(payment: Payment): PaymentResponseDto = PaymentResponseDto(
        payment.id ?: 0L,
        payment.paymentDateTime,
        payment.fromClientId,
        payment.toClientId,
        payment.summa,
        payment.currency.id,
        payment.status.id,
        payment.statusChangeReason ?: "",
        mapPaymentDetailToDto(payment.paymentDetail)
    )

    private fun mapPaymentDetailToDto(paymentDetail: Map<PaymentDetailFieldId, String>): PaymentDetailResponseDto {
        val paymentDetailResponseDto = PaymentDetailResponseDto()
        with(paymentDetailResponseDto) {
            note = MapperUtils.getIfNotEmpty(PaymentDetailFieldId.NOTE, paymentDetail)
        }
        return paymentDetailResponseDto
    }
}