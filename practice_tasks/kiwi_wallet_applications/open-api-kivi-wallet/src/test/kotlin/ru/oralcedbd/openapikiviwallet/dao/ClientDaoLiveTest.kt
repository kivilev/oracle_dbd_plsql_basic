package ru.oralcedbd.openapikiviwallet.dao

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringExtension

@ExtendWith(SpringExtension::class)
@ActiveProfiles("dev")
@SpringBootTest
class ClientDaoLiveTest {

    @Autowired
    lateinit var clientDao: ClientDao

    @Test
    fun createClient() {
        val clientData = mapOf(
            ClientDataFieldId.EMAIL to "email2@email.com",
            ClientDataFieldId.INN to "12345678903",
            ClientDataFieldId.FIRST_NAME to "firstName"
        )
        val clientId = clientDao.createClient(clientData)
        println("new client id: ${clientId}")
    }

    @Test
    fun getClient() {
        println(clientDao.getClient(122))
    }

    @Test
    fun changeClientData() {
        val id = 481L
        val clientData = mapOf(ClientDataFieldId.EMAIL to "newemail111@email.com")
        clientDao.changeClientData(id, clientData)
    }
}