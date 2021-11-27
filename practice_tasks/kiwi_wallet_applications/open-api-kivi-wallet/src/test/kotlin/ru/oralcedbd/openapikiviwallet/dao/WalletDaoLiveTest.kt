package ru.oralcedbd.openapikiviwallet.dao

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import ru.oralcedbd.openapikiviwallet.model.Currency

@SpringBootTest
class WalletDaoLiveTest {

    @Autowired
    lateinit var walletDao: WalletDao

    @Autowired
    lateinit var cientDao: ClientDao


    @Test
    fun `Create wallet`() {
        val clientData = mapOf(ClientDataFieldId.EMAIL to "email@enail.com")
        val clientId = cientDao.createClient(clientData)
        val walletId = walletDao.createWallet(clientId)
        println(walletId)
    }

    @Test
    fun `Create RUB account with balance`() {
        val clientData = mapOf(ClientDataFieldId.EMAIL to "email@enail.com")
        val clientId = cientDao.createClient(clientData)
        val walletId = walletDao.createWallet(clientId)
        val accountId = walletDao.addAccount(clientId, walletId, Currency.RUB, 200.22F)
        println(accountId)
    }
}