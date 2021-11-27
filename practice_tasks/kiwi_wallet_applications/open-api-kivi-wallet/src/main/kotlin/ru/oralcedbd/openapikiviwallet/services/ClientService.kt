package ru.oralcedbd.openapikiviwallet.services

import org.springframework.stereotype.Component
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientIdResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientResponseDto
import ru.oralcedbd.openapikiviwallet.dao.ClientDao
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.Currency
import java.util.*

interface ClientService {
    fun createClient(clientDataRequestDto: ClientDataRequestDto): ClientIdResponseDto
    fun getClient(id: Long): Optional<ClientResponseDto>
    fun changeClientData(id: Long, clientDataRequestDto: ClientDataRequestDto)
}

@Component
class ClientServiceImpl(private val clientDao: ClientDao, private val walletService: WalletService) : ClientService {

    override fun createClient(clientDataRequestDto: ClientDataRequestDto): ClientIdResponseDto {
        val clientId = clientDao.createClient(mapDtoToClientData(clientDataRequestDto))
        walletService.createWalletWithAccount(clientId, Currency.RUB, 0F)
        return ClientIdResponseDto(clientId)
    }

    override fun getClient(id: Long): Optional<ClientResponseDto> {
        val client = clientDao.getClient(id)
        val clientData = clientDao.getClientData(id)

        if (client.isPresent) {
            return Optional.of(mapClientToDto(client.get(), clientData))
        }

        return Optional.empty()
    }

    override fun changeClientData(id: Long, clientDataRequestDto: ClientDataRequestDto) {
        clientDao.changeClientData(id, mapDtoToClientData(clientDataRequestDto))
    }

    private fun mapClientToDto(client: Client, clientData: Map<ClientDataFieldId, String>) =
        ClientResponseDto(
            client.id,
            client.isActive,
            client.isBlocked,
            client.blocked_reason,
            mapClientDataToDto(clientData)
        )


    private fun mapClientDataToDto(clientData: Map<ClientDataFieldId, String>): ClientDataResponseDto {
        val clientDataResponseDto: ClientDataResponseDto = ClientDataResponseDto()
        with(clientDataResponseDto) {
            lastName = getIfNotEmpty(ClientDataFieldId.LAST_NAME, clientData)
            firstName = getIfNotEmpty(ClientDataFieldId.FIRST_NAME, clientData)
            sureName = getIfNotEmpty(ClientDataFieldId.SURE_NAME, clientData)
            inn = getIfNotEmpty(ClientDataFieldId.INN, clientData)
            birthDay = getIfNotEmpty(ClientDataFieldId.BIRTHDAY, clientData)
            email = getIfNotEmpty(ClientDataFieldId.EMAIL, clientData)
            mobilePhone = getIfNotEmpty(ClientDataFieldId.MOBILE_PHONE, clientData)
        }
        return clientDataResponseDto
    }

    private fun mapDtoToClientData(clientDataRequestDto: ClientDataRequestDto): Map<ClientDataFieldId, String> {
        val clientData = HashMap<ClientDataFieldId, String>()
        putIfExists(clientData, ClientDataFieldId.EMAIL, clientDataRequestDto.email)
        putIfExists(clientData, ClientDataFieldId.MOBILE_PHONE, clientDataRequestDto.mobilePhone)
        putIfExists(clientData, ClientDataFieldId.FIRST_NAME, clientDataRequestDto.firstName)
        putIfExists(clientData, ClientDataFieldId.LAST_NAME, clientDataRequestDto.lastName)
        putIfExists(clientData, ClientDataFieldId.SURE_NAME, clientDataRequestDto.sureName)
        putIfExists(clientData, ClientDataFieldId.INN, clientDataRequestDto.inn)
        putIfExists(clientData, ClientDataFieldId.BIRTHDAY, clientDataRequestDto.birthDay)
        return clientData
    }

    private fun putIfExists(map: MutableMap<ClientDataFieldId, String>, fieldId: ClientDataFieldId, value: String?) {
        if (!value.isNullOrBlank())
            map[fieldId] = value
    }

    private fun getIfNotEmpty(fieldId: ClientDataFieldId, map: Map<ClientDataFieldId, String>) =
        map.getOrDefault(fieldId, "")

}