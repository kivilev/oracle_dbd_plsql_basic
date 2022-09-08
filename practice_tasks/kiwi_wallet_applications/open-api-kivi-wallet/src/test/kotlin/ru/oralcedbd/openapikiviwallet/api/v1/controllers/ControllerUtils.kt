package ru.oralcedbd.openapikiviwallet.api.v1.controllers

import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.ResultMatcher
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import java.nio.charset.Charset

class ControllerUtils {
    companion object {
        fun executePutRequest(
            mockMvc: MockMvc,
            path: String, body: String,
            statusResultMatcher: ResultMatcher = MockMvcResultMatchers.status().is2xxSuccessful,
            vararg resultMatchers: ResultMatcher
        ): String {
            val resultActions = mockMvc.perform(
                MockMvcRequestBuilders.put(path)
                    .contentType(MediaType.APPLICATION_JSON_VALUE)
                    .content(body)
            ).andExpect(statusResultMatcher)

            for (matcher in resultMatchers) {
                resultActions.andExpect(matcher)
            }

            return resultActions.andReturn().response.getContentAsString(Charset.forName("UTF-8"))
        }

        fun executeGetRequest(
            mockMvc: MockMvc,
            path: String,
            statusResultMatcher: ResultMatcher = MockMvcResultMatchers.status().is2xxSuccessful,
            vararg resultMatchers: ResultMatcher
        ): String {
            val resultActions = mockMvc.perform(
                MockMvcRequestBuilders.get(path)
            ).andExpect(statusResultMatcher)

            for (matcher in resultMatchers) {
                resultActions.andExpect(matcher)
            }

            return resultActions.andReturn().response.getContentAsString(Charset.forName("UTF-8"))
        }

        fun executePostRequest(
            mockMvc: MockMvc,
            path: String,
            body: String,
            statusResultMatcher: ResultMatcher = MockMvcResultMatchers.status().is2xxSuccessful,
            vararg resultMatchers: ResultMatcher
        ): String {
            val resultActions = mockMvc.perform(
                MockMvcRequestBuilders.post(path)
                    .contentType(MediaType.APPLICATION_JSON_VALUE)
                    .content(body)
            ).andExpect(statusResultMatcher)

            for (matcher in resultMatchers) {
                resultActions.andExpect(matcher)
            }

            return resultActions.andReturn().response.getContentAsString(Charset.forName("UTF-8"))
        }
    }
}