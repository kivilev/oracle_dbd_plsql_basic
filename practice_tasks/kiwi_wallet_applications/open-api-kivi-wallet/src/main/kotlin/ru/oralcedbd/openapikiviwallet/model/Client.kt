package ru.oralcedbd.openapikiviwallet.model

import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId

typealias ClientData = Map<ClientDataFieldId, String>

data class Client(
    val id: Long,
    val isActive: Int,
    val isBlocked: Int,
    val blocked_reason: String,
) {
    constructor(
        id: Long,
        isActive: Int,
        isBlocked: Int,
        blocked_reason: String,
        clientData: ClientData
    ) : this(id, isActive, isBlocked, blocked_reason) {
        this.clientData = clientData
    }

    var clientData : ClientData = mapOf()
}