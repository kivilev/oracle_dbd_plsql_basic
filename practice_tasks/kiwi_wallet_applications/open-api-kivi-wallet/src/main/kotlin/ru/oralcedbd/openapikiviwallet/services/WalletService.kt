package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.dao.WalletDao
import ru.oralcedbd.openapikiviwallet.model.Account
import ru.oralcedbd.openapikiviwallet.model.Currency

interface WalletService {
    fun createWallet(clientId: Long): Long
    fun createWalletWithAccount(clientId: Long, currency: Currency, balance: Float): Long
    fun getAccounts(clientId: Long): Map<Currency, Account>
}

@Service
class WalletServiceImpl(private val walletDao: WalletDao) : WalletService {
    override fun createWallet(clientId: Long): Long {
        return walletDao.createWallet(clientId)
    }

    override fun createWalletWithAccount(clientId: Long, currency: Currency, balance: Float): Long {
        val walletId = walletDao.createWallet(clientId)
        walletDao.addAccount(clientId, walletId, currency, balance)
        return walletId
    }

    override fun getAccounts(clientId: Long): Map<Currency, Account> {
        return walletDao.getAccounts(clientId).associateBy { it.currency }
    }
}
