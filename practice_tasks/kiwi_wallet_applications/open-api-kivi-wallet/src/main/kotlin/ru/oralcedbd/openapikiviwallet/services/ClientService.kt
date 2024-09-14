package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.dao.ClientDao
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.ClientData
import java.util.Optional

@Service
class ClientService(
    private val clientDao: ClientDao
) {

    fun createClient(createClientData: Map<ClientDataFieldId, String>): Long {
        return clientDao.createClient(createClientData)
    }

    fun getClient(id: Long): Optional<Client> {
        val client = clientDao.getClient(id)

        if (!client.isPresent) {
            return Optional.empty()
        }

        client.get().clientData = clientDao.getClientData(id)

        return client
    }

    fun changeClientData(clientId: Long, clientData: ClientData) {
        clientDao.changeClientData(clientId, clientData)
    }
}