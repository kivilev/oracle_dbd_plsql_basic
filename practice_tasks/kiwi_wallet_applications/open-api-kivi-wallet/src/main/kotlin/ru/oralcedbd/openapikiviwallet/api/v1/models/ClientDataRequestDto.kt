package ru.oralcedbd.openapikiviwallet.api.v1.models

data class ClientDataRequestDto(
    val lastName: String?,
    val firstName: String?,
    val sureName: String?,
    val mobilePhone: String?,
    val email: String?,
    val inn: String?,
    val birthDay: String?
)