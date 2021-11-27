package ru.oralcedbd.openapikiviwallet.dao

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringExtension
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.Payment
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import java.time.ZonedDateTime

@ExtendWith(SpringExtension::class)
@ActiveProfiles("dev")
@SpringBootTest
class PaymentDaoLiveTest {

    @Autowired
    lateinit var paymentDao: PaymentDao

    @Test
    fun `Create new payment`() {
        val clientId = 21L
        val currency = Currency.RUB
        val summa = 10.10F
        val status = PaymentStatus.CREATED
        val paymentDetail = mapOf(PaymentDetailFieldId.NOTE to "Это примечание из теста")

        val payment = Payment(
            null, ZonedDateTime.now(), clientId, clientId, currency,
            summa, status, "", paymentDetail
        )

        val paymentId = paymentDao.createPayment(payment)
        assertNotNull(paymentId)
        println(paymentId)
    }
}