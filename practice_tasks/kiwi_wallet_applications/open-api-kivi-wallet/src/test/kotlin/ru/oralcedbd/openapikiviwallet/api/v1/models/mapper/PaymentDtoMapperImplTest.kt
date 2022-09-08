package ru.oralcedbd.openapikiviwallet.api.v1.models.mapper

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentDetailResponseDto
import ru.oralcedbd.openapikiviwallet.dao.PaymentDetailFieldId
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.Payment
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import java.time.ZonedDateTime

class PaymentDtoMapperImplTest {

    private val paymentDtoMapper = PaymentDtoMapperImpl()

    @Test
    fun `Full filled payment should map to dto object correctly`() {
        val payment = buildPayment()
        val paymentDto = paymentDtoMapper.mapPaymentToDto(payment)
        with(paymentDto) {
            assertEquals(PAYMENT_ID, id)
            assertEquals(PAYMENT_DATE_TIME, createDateTime)
            assertEquals(FROM_CLIENT_ID, fromClientId)
            assertEquals(TO_CLIENT_ID, toClientId)
            assertEquals(CURRENCY.id, currencyId)
            assertEquals(PAYMENT_SUM, summa)
            assertEquals(STATUS.id, status)
            assertEquals(STATUS_CHANGE_REASON, statusChangeReason)
            assertEquals(PAYMENT_DETAIL[PaymentDetailFieldId.NOTE], paymentDetail.note)
        }
    }

    @Test
    fun `Payment without payment details should map to dto object correctly`() {
        val payment = buildPayment(paymentDetail = emptyMap())
        val paymentDto = paymentDtoMapper.mapPaymentToDto(payment)
        assertEquals(PaymentDetailResponseDto(), paymentDto.paymentDetail)
    }

    @Test
    fun `Payment with null change reason should map to dto object correctly`() {
        val payment = buildPayment(statusChangeReason = null)
        val paymentDto = paymentDtoMapper.mapPaymentToDto(payment)
        assertEquals("", paymentDto.statusChangeReason)
    }

    @Test
    fun `Payment without paymentId should map to dto object correctly`() {
        val payment = buildPayment(id = null)
        val paymentDto = paymentDtoMapper.mapPaymentToDto(payment)
        assertEquals(0L, paymentDto.id)
    }


    private fun buildPayment(
        id: Long? = PAYMENT_ID,
        paymentDateTime: ZonedDateTime = PAYMENT_DATE_TIME,
        fromClientId: Long = FROM_CLIENT_ID,
        toClientId: Long = TO_CLIENT_ID,
        currency: Currency = CURRENCY,
        summa: Double = PAYMENT_SUM,
        status: PaymentStatus = STATUS,
        statusChangeReason: String? = STATUS_CHANGE_REASON,
        paymentDetail: Map<PaymentDetailFieldId, String> = PAYMENT_DETAIL
    ) =
        Payment(
            id,
            paymentDateTime,
            fromClientId,
            toClientId,
            currency,
            summa,
            status,
            statusChangeReason,
            paymentDetail
        )


    private companion object {
        const val PAYMENT_ID = 1234L
        const val PAYMENT_SUM = 123.33
        val PAYMENT_DATE_TIME: ZonedDateTime = ZonedDateTime.now()
        const val FROM_CLIENT_ID = 1L
        const val TO_CLIENT_ID = 2L
        val CURRENCY = Currency.USD
        val STATUS = PaymentStatus.CREATED
        const val STATUS_CHANGE_REASON = "Reason"
        const val NOTE = "note"
        const val IP = "127.0.0.1"
        val PAYMENT_DETAIL = mapOf(PaymentDetailFieldId.NOTE to NOTE, PaymentDetailFieldId.IP to IP)
    }
}