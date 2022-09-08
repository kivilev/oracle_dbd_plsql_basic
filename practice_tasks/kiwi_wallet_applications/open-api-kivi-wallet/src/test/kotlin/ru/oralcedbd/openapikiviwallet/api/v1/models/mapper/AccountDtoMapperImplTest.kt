package ru.oralcedbd.openapikiviwallet.api.v1.models.mapper

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import ru.oralcedbd.openapikiviwallet.model.Account
import ru.oralcedbd.openapikiviwallet.model.Currency

class AccountDtoMapperTest {

    private val accountDtoMapper = AccountDtoMapperImpl();

    @Test
    fun `Full filled account should map correctly`() {
        val account = Account(CLIENT_ID, WALLET_ID, ACCOUNT_ID, CURRENCY, BALANCE)
        val accountsResponseDto = accountDtoMapper.mapAccountToAccountsResponseDto(account)
        with(accountsResponseDto) {
            assertEquals(CURRENCY.id, currencyId)
            assertEquals(CURRENCY.name, currencyName)
            assertEquals(BALANCE, balance)
        }
    }

    private companion object {
        const val CLIENT_ID = 123L
        const val WALLET_ID = 1234L
        const val ACCOUNT_ID = 12345L
        val CURRENCY = Currency.USD
        const val BALANCE = 100.11
    }
}