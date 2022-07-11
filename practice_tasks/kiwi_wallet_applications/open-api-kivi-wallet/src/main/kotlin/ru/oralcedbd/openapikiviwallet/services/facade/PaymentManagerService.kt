package ru.oralcedbd.openapikiviwallet.services.facade

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.api.v1.models.PaymentResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.mapper.PaymentDtoMapper
import ru.oralcedbd.openapikiviwallet.services.PaymentService

interface PaymentManagerService {
    fun getPayments(clientId: Long): List<PaymentResponseDto>
}

@Service
class PaymentManagerServiceImpl(
    private val paymentService: PaymentService,
    private val paymentDtoMapper: PaymentDtoMapper
) : PaymentManagerService {

    override fun getPayments(clientId: Long): List<PaymentResponseDto> {
        return paymentService.getPayments(clientId).map { paymentDtoMapper.mapPaymentToDto(it) }
    }
}