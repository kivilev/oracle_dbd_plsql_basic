package ru.oralcedbd.openapikiviwallet.webcontroller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import ru.oralcedbd.openapikiviwallet.dao.ClientDataFieldId
import ru.oralcedbd.openapikiviwallet.model.Currency
import ru.oralcedbd.openapikiviwallet.services.ClientService
import ru.oralcedbd.openapikiviwallet.services.PaymentService
import ru.oralcedbd.openapikiviwallet.services.WalletService

@Controller
class WebSiteController(
    val walletService: WalletService,
    val paymentService: PaymentService,
    val clientService: ClientService
) {

    @GetMapping
    fun main(): String {
        return "main"
    }

    @GetMapping("/lk")
    fun privateCabinet(
        @RequestParam(name = "client_id", required = true) clientId: Long,
        model: Model
    ): String {
        val accounts = walletService.getAccounts(clientId);
        val client = clientService.getClient(clientId);
        var fio: String = ""
        with(client.get().clientData) {
            fio =
                String.format(
                    "%s %s %s",
                    this[ClientDataFieldId.FIRST_NAME] ?: "",
                    this[ClientDataFieldId.SURE_NAME] ?: "",
                    this[ClientDataFieldId.LAST_NAME] ?: ""
                )
        }
        model.addAttribute("client_id", clientId.toString())
        model.addAttribute("rub_balance", accounts[Currency.RUB]?.balance ?: 0.0)
        model.addAttribute("usd_balance", accounts[Currency.USD]?.balance ?: 0.0)
        model.addAttribute("eur_balance", accounts[Currency.EUR]?.balance ?: 0.0)
        model.addAttribute("fio", fio)
        return "lk"
    }

    @GetMapping("/payments")
    fun payments(
        @RequestParam(name = "client_id", required = true) clientId: Long,
        model: Model
    ): String {
        model.addAttribute("client_id", clientId.toString());
        model.addAttribute("paymentList", paymentService.getPayments(clientId));
        return "payments"
    }

    @GetMapping("/options")
    fun options(
        @RequestParam(name = "client_id", required = true) clientId: Long,
        model: Model
    ): String {
        model.addAttribute("client_id", clientId.toString());
        return "options"
    }

    @GetMapping("/signup")
    fun registration(): String {
        return "signup"
    }

    @GetMapping("/signin")
    fun signIn(): String {
        return "signin"
    }


}