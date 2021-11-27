package ru.oralcedbd.openapikiviwallet.api.v1.models

data class ClientResponseDto(
    val id: Long,
    val active: Int,
    val blocked: Int,
    val blockedReason: String? = "",
    val clientData: ClientDataResponseDto? = null
)