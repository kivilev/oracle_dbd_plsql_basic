package ru.oralcedbd.openapikiviwallet.utils

/**
 * Необходимо для использования Mockito в kotlin:
 * решает проблему с теми ArgumentMatchers, которые возвращают null
 */
/*

fun <T> any(): T {
    Mockito.any<T>()
    return uninitialized()
}

fun <T> eq(value: T): T {
    Mockito.eq<T>(value)
    return uninitialized()
}

fun <T> same(value: T): T {
    Mockito.same<T>(value)
    return uninitialized()
}

fun eq(value: Double) = Mockito.eq(value)
fun eq(value: Float) = Mockito.eq(value)
fun eq(value: Long) = Mockito.eq(value)
fun eq(value: Int) = Mockito.eq(value)
fun eq(value: Short) = Mockito.eq(value)
fun eq(value: Byte) = Mockito.eq(value)
fun eq(value: Boolean) = Mockito.eq(value)
fun eq(value: Char) = Mockito.eq(value)

fun <T> notNull(): T {
    Mockito.notNull<T>()
    return uninitialized()
}

fun <T> argThat(matcher: ArgumentMatcher<*>): T {
    Mockito.argThat(matcher)
    return uninitialized()
}

fun <T> capture(captor: ArgumentCaptor<*>): T {
    captor.capture()
    return uninitialized()
}

@Suppress("UNCHECKED_CAST")
private fun <T> uninitialized(): T = null as T
*/
