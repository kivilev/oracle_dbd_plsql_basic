package ru.oralcedbd.openapikiviwallet.services

import org.slf4j.LoggerFactory
import org.springframework.context.annotation.Primary
import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.model.Client


interface ClientNotificationService {
    fun creationClientNotify(client: Client)
}

@Service
@Primary
class ClientNotificationServiceKafka : ClientNotificationService {
    private val log = LoggerFactory.getLogger(ClientNotificationServiceKafka::class.java)

    override fun creationClientNotify(client: Client) {
        log.info("Sending message to Kafka about client creation. ${client.id} ...")
    }
}

@Service
class ClientNotificationServiceRabbitMq : ClientNotificationService {
    private val log = LoggerFactory.getLogger(ClientNotificationServiceRabbitMq::class.java)

    override fun creationClientNotify(client: Client) {
        log.info("Sending message to RabbitMQ about client creation. ${client.id} ...")
    }
}