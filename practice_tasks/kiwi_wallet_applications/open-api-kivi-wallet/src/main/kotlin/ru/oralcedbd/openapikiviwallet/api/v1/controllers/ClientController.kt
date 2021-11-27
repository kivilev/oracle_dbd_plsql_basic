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
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientDataRequestDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientIdResponseDto
import ru.oralcedbd.openapikiviwallet.api.v1.models.ClientResponseDto
import ru.oralcedbd.openapikiviwallet.services.ClientService


@RestController
@RequestMapping(
    "/api/v1/clients",
    produces = [org.springframework.http.MediaType.APPLICATION_JSON_VALUE]
)
class ClientController(private val clientService: ClientService) {

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    fun createClient(
        @RequestBody
        body: ClientDataRequestDto
    ): ClientIdResponseDto {
        return clientService.createClient(body)
    }

    @PutMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    fun changeClientData(
        @PathVariable("id")
        id: Long,
        @RequestBody
        body: ClientDataRequestDto
    ) {
        clientService.changeClientData(id, body)
    }

    @GetMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    fun clientInfo(@PathVariable id: Long): ClientResponseDto {
        val client = clientService.getClient(id)
        if (!client.isPresent) throw ResponseStatusException(HttpStatus.NOT_FOUND, ERROR_MESSAGE_CLIENT_NOT_FOUND)
        return client.get()
    }
}