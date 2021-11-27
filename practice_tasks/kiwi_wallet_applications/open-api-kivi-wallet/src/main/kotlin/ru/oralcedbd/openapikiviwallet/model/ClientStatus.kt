package ru.oralcedbd.openapikiviwallet.model

enum class PaymentStatus(val id: Int) {
    CREATED(0),
    SUCCESSFUL_PROCESSED(1),
    FINISHED_WITH_ERROR(2),
    CANCELLED(3)
}