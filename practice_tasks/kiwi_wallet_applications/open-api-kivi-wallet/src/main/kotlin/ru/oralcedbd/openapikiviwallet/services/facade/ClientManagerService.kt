package ru.oralcedbd.openapikiviwallet.services.facade

import org.springframework.stereotype.Service
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientCreateResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.mapper.ClientDtoMapper
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.services.BonusService
import ru.oralcedbd.openapikiviwallet.services.ClientNotificationService
import ru.oralcedbd.openapikiviwallet.services.ClientService
import ru.oralcedbd.openapikiviwallet.services.WalletService
import java.util.Optional

interface ClientManagerService {
    fun createClient(clientDataRequestDto: ClientDataRequestDto): ClientCreateResponseDto
    fun getClient(id: Long): Optional<ClientResponseDto>
    fun changeClientData(id: Long, clientDataRequestDto: ClientDataRequestDto)
}

@Service
class ClientManagerServiceImpl(
    private val clientService: ClientService,
    private val walletService: WalletService,
    private val bonusService: BonusService,
    private val notificationService: ClientNotificationService,
    private val clientDtoMapper: ClientDtoMapper
) : ClientManagerService {
    override fun createClient(clientDataRequestDto: ClientDataRequestDto): ClientCreateResponseDto {
        val clientData = clientDtoMapper.mapClientCreateRequest(clientDataRequestDto)

        val clientId = clientService.createClient(clientData)

        val client = clientService.getClient(clientId)
        if (!client.isPresent) {
            throw RuntimeException("Client not found")
        }

        walletService.createWalletWithAccount(clientId, Currency.RUB, 0F)

        bonusService.putToClient(clientId, Currency.RUB, bonusService.getDefaultAmount(Currency.RUB))

        notificationService.creationClientNotify(client.get())

        return ClientCreateResponseDto(clientId)
    }

    override fun getClient(id: Long): Optional<ClientResponseDto> {
        val client = clientService.getClient(id)

        if (!client.isPresent) {
            return Optional.empty()
        }

        return Optional.of(clientDtoMapper.mapClientToGetClientResponse(client.get()))
    }

    override fun changeClientData(id: Long, clientDataRequestDto: ClientDataRequestDto) {
        val clientData = clientDtoMapper.mapClientDataFromGetRequest(clientDataRequestDto)
        clientService.changeClientData(id, clientData)
    }
}