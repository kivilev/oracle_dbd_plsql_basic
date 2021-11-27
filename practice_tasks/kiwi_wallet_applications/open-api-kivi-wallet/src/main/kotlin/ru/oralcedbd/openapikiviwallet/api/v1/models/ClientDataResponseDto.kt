package ru.oralcedbd.openapikiviwallet.api.v1.models

data class ClientDataResponseDto(
    var lastName: String? = "",
    var firstName: String? = "",
    var sureName: String? = "",
    var mobilePhone: String? = "",
    var email: String? = "",
    var inn: String? = "",
    var birthDay: String? = ""
)