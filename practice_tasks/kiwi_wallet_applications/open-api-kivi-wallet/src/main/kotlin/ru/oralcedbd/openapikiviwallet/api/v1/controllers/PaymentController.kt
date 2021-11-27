package ru.oralcedbd.openapikiviwallet.api.v1.controllers

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentIdResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentResponseDto
import ru.oralcedbd.openapikiviwallet.services.PaymentService

@RestController
@RequestMapping("/api/v1/payments/")
class PaymentController(private val paymentService: PaymentService) {

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    fun createPayment(
        @RequestBody paymentRequestDto: PaymentRequestDto
    ): PaymentIdResponseDto {
        return paymentService.createPayment(paymentRequestDto)
    }

    @GetMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    fun paymentInfo(@PathVariable id: Long): PaymentResponseDto {
        val payment = paymentService.getPayment(id)
        if (!payment.isPresent) throw ResponseStatusException(
            HttpStatus.NOT_FOUND,
            RestErrors.ERROR_MESSAGE_PAYMENT_NOT_FOUND
        )
        return payment.get()
    }
}