package ru.oralcedbd.openapikiviwallet.services

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.model.Currency

@Service
class BonusService {
    private val log = LoggerFactory.getLogger(ClientNotificationServiceKafka::class.java)

    fun putToClient(clientId: Long, currency: Currency, amount: Float) {
        // дергаем DAO, которое зачисляет на бонусный счет бонусы
        log.info("Added bonuses $amount ${currency.name} for client $clientId")
    }

    fun getDefaultAmount(currency: Currency): Float {
        // дергаем DAO с кэшем, для считывания из таблицы в БД дефолтный размер для валюты бонусов
        return 0F
    }
}