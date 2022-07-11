package ru.oralcedbd.openapikiviwallet.api.v1.models

data class AccountsResponseDto(
    val currencyId: Int,
    val currencyName: String,
    val balance: Float
)