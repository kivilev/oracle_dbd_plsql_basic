package ru.oralcedbd.openapikiviwallet.model

data class Account(
    val clientId: Long,
    val walletId: Long,
    val accountId: Long,
    val currency: Currency,
    val balance: Float
)