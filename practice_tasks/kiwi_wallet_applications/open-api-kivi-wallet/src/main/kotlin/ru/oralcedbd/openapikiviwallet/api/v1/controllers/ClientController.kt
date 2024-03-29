package ru.oralcedbd.openapikiviwallet.api.v1.controllers

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException
import ru.oralcedbd.openapikiviwallet.api.v1.controllers.RestErrors.ERROR_MESSAGE_CLIENT_NOT_FOUND
import ru.oralcedbd.openapikiviwallet.api.v1.models.AccountsResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientCreateResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientResponseDto
import ru.oralcedbd.openapikiviwallet.services.facade.ClientManagerService
import ru.oralcedbd.openapikiviwallet.services.facade.WalletManagerService


@RestController
@RequestMapping(
    "/api/v1/clients",
    produces = [org.springframework.http.MediaType.APPLICATION_JSON_VALUE]
)
class ClientController(
    private val clientManagerService: ClientManagerService,
    private val walletManagerService: WalletManagerService
) {

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    fun createClient(
        @RequestBody
        body: ClientDataRequestDto
    ): ClientCreateResponseDto {
        return clientManagerService.createClient(body)
    }

    @PutMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    fun changeClientData(
        @PathVariable("id")
        id: Long,
        @RequestBody
        body: ClientDataRequestDto
    ) {
        clientManagerService.changeClientData(id, body)
    }

    @GetMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    fun clientInfo(@PathVariable id: Long): ClientResponseDto {
        val client = clientManagerService.getClient(id)
        if (!client.isPresent) throw ResponseStatusException(HttpStatus.NOT_FOUND, ERROR_MESSAGE_CLIENT_NOT_FOUND)
        return client.get()
    }

    @GetMapping("{id}/balances")
    @ResponseStatus(HttpStatus.OK)
    fun clientBalances(@PathVariable id: Long): List<AccountsResponseDto> {
        return walletManagerService.getClientBalances(id)
    }
}