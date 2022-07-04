package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentDetailRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentDetailResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentIdResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentResponseDto
import ru.oralcedbd.openapikiviwallet.dao.PaymentDao
import ru.oralcedbd.openapikiviwallet.dao.PaymentDetailFieldId
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.Payment
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import ru.oralcedbd.openapikiviwallet.utils.EnumIdValueMap
import ru.oralcedbd.openapikiviwallet.utils.MapperUtils.getIfNotEmpty
import ru.oralcedbd.openapikiviwallet.utils.MapperUtils.putIfExists
import java.time.ZonedDateTime
import java.util.Optional

interface PaymentService {
    fun createPayment(
        paymentRequestDto: PaymentRequestDto
    ): PaymentIdResponseDto

    fun getPayment(id: Long): Optional<PaymentResponseDto>
    fun getPayments(clientId: Long): List<Payment>
}

@Service
class PaymentServiceImpl(
    private val paymentDao: PaymentDao,
    private val currencyEnumIdValueMap: EnumIdValueMap<Int, Currency>
) : PaymentService {

    override fun createPayment(paymentRequestDto: PaymentRequestDto): PaymentIdResponseDto {
        val payment = mapDtoToPayment(paymentRequestDto)
        payment.paymentDetail = enrichPaymentDetail(payment.paymentDetail)
        return PaymentIdResponseDto(paymentDao.createPayment(payment))
    }

    override fun getPayment(id: Long): Optional<PaymentResponseDto> {
        val payment = paymentDao.getPayment(id)
        val paymentDetail = paymentDao.getPaymentDetail(id)
        if (payment.isPresent) {
            return Optional.of(mapPaymentToDto(payment.get(), paymentDetail))
        }
        return Optional.empty()
    }

    override fun getPayments(clientId: Long): List<Payment> {
        return paymentDao.getPayments(clientId);
    }

    private fun mapDtoToPayment(paymentRequestDto: PaymentRequestDto) =
        Payment(
            null,
            ZonedDateTime.now(),
            paymentRequestDto.fromClientId,
            paymentRequestDto.toClientId,
            currencyEnumIdValueMap.toValue(paymentRequestDto.currencyId),
            paymentRequestDto.summa,
            PaymentStatus.CREATED,
            "",
            mapDtoToPaymentDetail(paymentRequestDto.paymentDetail)
        )

    private fun mapDtoToPaymentDetail(paymentDetail: PaymentDetailRequestDto): Map<PaymentDetailFieldId, String> {
        val paymentDetailMap = HashMap<PaymentDetailFieldId, String>()
        putIfExists(paymentDetailMap, PaymentDetailFieldId.NOTE, paymentDetail.note)
        return paymentDetailMap
    }

    private fun enrichPaymentDetail(paymentDetail: Map<PaymentDetailFieldId, String>): Map<PaymentDetailFieldId, String> {
        val paymentDetailMap = paymentDetail.toMutableMap()
        paymentDetailMap[PaymentDetailFieldId.CLIENT_SOFTWARE] = "Android v.9.0"//получаем описание клиента
        paymentDetailMap[PaymentDetailFieldId.IP] = "127.0.0.1"//получаем IP
        return paymentDetailMap
    }

    private fun mapPaymentToDto(
        payment: Payment,
        paymentDetail: Map<PaymentDetailFieldId, String>
    ) = PaymentResponseDto(
        payment.id ?: 0L,
        payment.paymentDateTime,
        payment.fromClientId,
        payment.toClientId,
        payment.summa,
        payment.currency.id,
        payment.status.id,
        payment.statusChangeReason ?: "",
        mapPaymentDetailToDto(paymentDetail)
    )

    private fun mapPaymentDetailToDto(paymentDetail: Map<PaymentDetailFieldId, String>): PaymentDetailResponseDto {
        val paymentDetailResponseDto = PaymentDetailResponseDto()
        with(paymentDetailResponseDto) {
            note = getIfNotEmpty(PaymentDetailFieldId.NOTE, paymentDetail)
        }
        return paymentDetailResponseDto
    }
}