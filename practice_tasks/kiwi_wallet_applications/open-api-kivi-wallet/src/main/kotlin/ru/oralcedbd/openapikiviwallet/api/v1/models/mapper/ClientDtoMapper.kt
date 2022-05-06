package ru.oralcedbd.openapikiviwallet.api.v1.models.mapper

import org.springframework.stereotype.Component
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientResponseDto
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.model.Client
import ru.oralcedbd.openapikiviwallet.model.ClientData
import ru.oralcedbd.openapikiviwallet.utils.MapperUtils

interface ClientDtoMapper {
    fun mapClientDataToResponse(clientData: ClientData): ClientDataResponseDto
    fun mapClientCreateRequest(clientDataRequestDto: ClientDataRequestDto): ClientData
    fun mapClientToGetClientResponse(client: Client): ClientResponseDto
    fun mapClientDataFromGetRequest(clientDataRequestDto: ClientDataRequestDto): ClientData
}

@Component
class ClientDtoMapperImpl : ClientDtoMapper {

    override fun mapClientDataToResponse(clientData: ClientData): ClientDataResponseDto {
        val clientDataResponseDto: ClientDataResponseDto = ClientDataResponseDto()
        with(clientDataResponseDto) {
            lastName = MapperUtils.getIfNotEmpty(ClientDataFieldId.LAST_NAME, clientData)
            firstName = MapperUtils.getIfNotEmpty(ClientDataFieldId.FIRST_NAME, clientData)
            sureName = MapperUtils.getIfNotEmpty(ClientDataFieldId.SURE_NAME, clientData)
            inn = MapperUtils.getIfNotEmpty(ClientDataFieldId.INN, clientData)
            birthDay = MapperUtils.getIfNotEmpty(ClientDataFieldId.BIRTHDAY, clientData)
            email = MapperUtils.getIfNotEmpty(ClientDataFieldId.EMAIL, clientData)
            mobilePhone = MapperUtils.getIfNotEmpty(ClientDataFieldId.MOBILE_PHONE, clientData)
        }
        return clientDataResponseDto
    }

    override fun mapClientCreateRequest(clientDataRequestDto: ClientDataRequestDto): ClientData {
        return mapClientDataFromRequest(clientDataRequestDto)
    }

    override fun mapClientDataFromGetRequest(clientDataRequestDto: ClientDataRequestDto): ClientData {
        return mapClientDataFromRequest(clientDataRequestDto)
    }

    private fun mapClientDataFromRequest(clientDataRequestDto: ClientDataRequestDto): ClientData {
        val clientData = HashMap<ClientDataFieldId, String>()
        MapperUtils.putIfExists(clientData, ClientDataFieldId.EMAIL, clientDataRequestDto.email)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.MOBILE_PHONE, clientDataRequestDto.mobilePhone)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.FIRST_NAME, clientDataRequestDto.firstName)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.LAST_NAME, clientDataRequestDto.lastName)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.SURE_NAME, clientDataRequestDto.sureName)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.INN, clientDataRequestDto.inn)
        MapperUtils.putIfExists(clientData, ClientDataFieldId.BIRTHDAY, clientDataRequestDto.birthDay)
        return clientData
    }

    override fun mapClientToGetClientResponse(client: Client): ClientResponseDto {
        return ClientResponseDto(
            client.id,
            client.isActive,
            client.isBlocked,
            client.blocked_reason,
            mapClientDataToResponse(client.clientData)
        )
    }

}