package ru.oralcedbd.openapikiviwallet.dao

enum class ClientDataFieldId(val id: Long) : FieldId {
    EMAIL(1),
    MOBILE_PHONE(2),
    INN(3),
    BIRTHDAY(4),
    LAST_NAME(5),
    FIRST_NAME(6),
    SURE_NAME(7),
    IS_TECH_CLIENT(8),
    TECH_NAME(9),
    TECH_ADDRESS(10)
}