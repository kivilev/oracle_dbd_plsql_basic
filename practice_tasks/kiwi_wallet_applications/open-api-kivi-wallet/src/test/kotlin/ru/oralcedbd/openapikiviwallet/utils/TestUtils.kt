package ru.oralcedbd.openapikiviwallet.utils

import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.ClientData

class TestUtils {

    companion object {

        fun buildClient(
            id: Long = CLIENT_ID,
            isActive: Int = CLIENT_IS_ACTIVE,
            isBlocked: Int = CLIENT_IS_BLOCKED,
            blocked_reason: String = BLOCKED_REASON,
            clientData: ClientData = emptyMap()
        ): Client =
            Client(id, isActive, isBlocked, blocked_reason, clientData)


        private const val CLIENT_ID = 1L
        private const val CLIENT_IS_ACTIVE = 1
        private const val CLIENT_IS_BLOCKED = 0
        private const val BLOCKED_REASON = ""
    }
}