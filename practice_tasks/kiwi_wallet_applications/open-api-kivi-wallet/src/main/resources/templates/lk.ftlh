<#import "parts/common_lk.ftlh" as c>
<@c.page>
    <div class="container">
        <h4>Добро пожаловать, ${fio}!</h4>
    </div>
    <br/>
    <div class="container">
        Баланс:
        <table class="table">
            <tbody>
            <tr>
                <th scope="row">RUB</th>
                <td>${rub_balance}</td>
            </tr>
            <tr>
                <th scope="row">USD</th>
                <td>${usd_balance}</td>
            </tr>
            <tr>
                <th scope="row">EUR</th>
                <td>${eur_balance}</td>
            </tr>
            </tbody>
        </table>
    </div>
</@c.page>