package ru.oralcedbd.openapikiviwallet.api.v1.controllers

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.test.web.servlet.MockMvc
import ru.oralcedbd.openapikiviwallet.dao.ClientDao
import ru.oralcedbd.openapikiviwallet.dao.PaymentDao
import ru.oralcedbd.openapikiviwallet.dao.WalletDao
import ru.oralcedbd.openapikiviwallet.services.BonusService
import ru.oralcedbd.openapikiviwallet.services.ClientNotificationService
import ru.oralcedbd.openapikiviwallet.services.WalletService

abstract class ControllerTestBase {
    @Autowired
    lateinit var mockMvc: MockMvc

    @MockBean
    lateinit var paymentDao: PaymentDao

    @MockBean
    lateinit var walletDao: WalletDao

    @MockBean
    lateinit var clientDao: ClientDao

    //@MockBean
    //lateinit var clientService: ClientService

    @MockBean
    lateinit var walletService: WalletService

    @MockBean
    lateinit var bonusService: BonusService

    @MockBean
    lateinit var notificationService: ClientNotificationService
}