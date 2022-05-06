package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Component
import ru.oralcedbd.openapikiviwallet.dao.ClientDao
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.ClientData
import java.util.Optional

interface ClientService {
    fun createClient(createClientData: ClientData): Long
    fun getClient(id: Long): Optional<Client>
    fun changeClientData(clientId: Long, clientData: ClientData)
}

@Component
class ClientServiceImpl(
    private val clientDao: ClientDao
) : ClientService {

    override fun createClient(createClientData: Map<ClientDataFieldId, String>): Long {
        return clientDao.createClient(createClientData)
    }

    override fun getClient(id: Long): Optional<Client> {
        val client = clientDao.getClient(id)

        if (!client.isPresent) {
            return Optional.empty()
        }

        client.get().clientData = clientDao.getClientData(id)

        return client
    }

    override fun changeClientData(clientId: Long, clientData: ClientData) {
        clientDao.changeClientData(clientId, clientData)
    }
}