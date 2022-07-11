package ru.oralcedbd.openapikiviwallet.services.facade

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.api.v1.models.AccountsResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.mapper.AccountDtoMapper
import ru.oralcedbd.openapikiviwallet.services.WalletService

interface WalletManagerService {
    fun getClientBalances(clientId: Long): List<AccountsResponseDto>
}

@Service
class WalletManagerServiceImpl(
    private val walletService: WalletService,
    private val accountDtoMapper: AccountDtoMapper
) : WalletManagerService {

    override fun getClientBalances(clientId: Long): List<AccountsResponseDto> =
        walletService.getAccounts(clientId).map { accountDtoMapper.mapAccountToAccountsResponseDto(it.value) }

}

