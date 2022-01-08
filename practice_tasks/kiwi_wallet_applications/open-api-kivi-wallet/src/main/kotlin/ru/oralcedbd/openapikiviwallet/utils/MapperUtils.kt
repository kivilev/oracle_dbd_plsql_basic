package ru.oralcedbd.openapikiviwallet.utils

import ru.oralcedbd.openapikiviwallet.dao.FieldId

object MapperUtils {

    fun <T : FieldId> putIfExists(
        map: HashMap<T, String>,
        fieldId: T,
        value: String?
    ) {
        if (!value.isNullOrBlank())
            map[fieldId] = value
    }

    fun <T : FieldId> getIfNotEmpty(fieldId: T, map: Map<T, String>) =
        map.getOrDefault(fieldId, "")
}