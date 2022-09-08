package ru.oralcedbd.openapikiviwallet.api.v1.controllers

import com.nhaarman.mockitokotlin2.any
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import ru.oralcedbd.openapikiviwallet.OpenapiKiviWalletApplication
import ru.oralcedbd.openapikiviwallet.api.v1.controllers.ControllerUtils.Companion.executePostRequest
import ru.oralcedbd.openapikiviwallet.utils.TestUtils
import java.util.Optional

@SpringBootTest(classes = [OpenapiKiviWalletApplication::class])
@AutoConfigureMockMvc
class ClientControllerTest : ControllerTestBase() {

    @Test
    fun `Create client request with correct client data`() {
        val client = TestUtils.buildClient(id = NEW_CLIENT_ID)
        `when`(clientDao.createClient(any())).thenReturn(NEW_CLIENT_ID)
        `when`(clientDao.getClient(NEW_CLIENT_ID)).thenReturn(Optional.of(client))

        val answer = executePostRequest(mockMvc, CLIENT_PATH, CLIENT_CREATE_JSON)

        assertEquals(CLIENT_CREATE_CORRECT_ANSWER, answer)
    }

    private companion object {
        const val NEW_CLIENT_ID = 1L
        const val CLIENT_PATH = "/api/v1/clients"
        const val CLIENT_CREATE_JSON = """
        {
          "email": "milicioner77@gmail.com",
          "birthDay": "1977-03-06",
          "mobilePhone": "+79999137800",
          "lastName": "Яковлев",
          "firstName": "Владимир",
          "inn": "1234567890"
        }
        """
        const val CLIENT_CREATE_CORRECT_ANSWER = "{\"clientId\":$NEW_CLIENT_ID}"
    }
}