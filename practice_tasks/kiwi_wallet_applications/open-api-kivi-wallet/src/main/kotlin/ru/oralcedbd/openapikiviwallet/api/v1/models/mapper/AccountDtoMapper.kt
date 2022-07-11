package ru.oralcedbd.openapikiviwallet.api.v1.models.mapper

import org.springframework.stereotype.Component
import ru.oralcedbd.openapikiviwallet.api.v1.models.AccountsResponseDto
import ru.oralcedbd.openapikiviwallet.model.Account

interface AccountDtoMapper {
    fun mapAccountToAccountsResponseDto(account: Account): AccountsResponseDto
}

@Component
class AccountDtoMapperImpl : AccountDtoMapper {
    override fun mapAccountToAccountsResponseDto(account: Account): AccountsResponseDto =
        AccountsResponseDto(account.currency.id, account.currency.name, account.balance)
}

