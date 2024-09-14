package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.dao.WalletDao
import ru.oralcedbd.openapikiviwallet.model.Account
import ru.oralcedbd.openapikiviwallet.model.Currency

@Service
class WalletService(private val walletDao: WalletDao) {

    fun createWalletWithAccount(clientId: Long, currency: Currency, balance: Float): Long {
        val walletId = walletDao.createWallet(clientId)
        walletDao.addAccount(clientId, walletId, currency, balance)
        return walletId
    }

    fun getAccounts(clientId: Long): Map<Currency, Account> {
        return walletDao.getAccounts(clientId).associateBy { it.currency }
    }
}
