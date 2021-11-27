package ru.oralcedbd.openapikiviwallet.dao

enum class PaymentDetailFieldId(val id: Long) {
    CLIENT_SOFTWARE(1L),
    IP(2L),
    NOTE(3L),
    IS_CHECKED_FRAUD(4L)
}