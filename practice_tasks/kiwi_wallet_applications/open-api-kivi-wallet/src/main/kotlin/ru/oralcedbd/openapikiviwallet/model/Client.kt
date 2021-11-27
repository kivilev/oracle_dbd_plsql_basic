package ru.oralcedbd.openapikiviwallet.model

data class Client(val id: Long, val isActive: Int, val isBlocked: Int, val blocked_reason: String)