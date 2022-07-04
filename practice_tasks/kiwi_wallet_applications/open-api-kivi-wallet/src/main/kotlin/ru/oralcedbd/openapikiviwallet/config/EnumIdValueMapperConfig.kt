package ru.oralcedbd.openapikiviwallet.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.dao.PaymentDetailFieldId
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.model.PaymentStatus
import ru.oralcedbd.openapikiviwallet.utils.EnumIdValueMap

@Configuration
class EnumIdValueMapperConfig {
    @Bean
    fun getPaymentDetailEnumIdValueMapper(): EnumIdValueMap<Long, PaymentDetailFieldId> =
        EnumIdValueMap(PaymentDetailFieldId::class.java, PaymentDetailFieldId::id)

    @Bean
    fun getPaymentStatusEnumIdValueMapper(): EnumIdValueMap<Int, PaymentStatus> =
        EnumIdValueMap(PaymentStatus::class.java, PaymentStatus::id)

    @Bean
    fun getCurrencyEnumIdValueMapper(): EnumIdValueMap<Int, Currency> =
        EnumIdValueMap(Currency::class.java, Currency::id)

    @Bean
    fun getClientDataEnumIdValueMapper(): EnumIdValueMap<Long, ClientDataFieldId> =
        EnumIdValueMap(ClientDataFieldId::class.java, ClientDataFieldId::id)
}
