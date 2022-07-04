<#import "parts/common_lk.ftlh" as c>
<@c.page>

    <div class="container">
        <h4>Список платежей</h4>
    </div>
    <br/>
    <div class="container">

        <table class="table">
            <thead>
            <tr>
                <th scope="col">#</th>
                <th scope="col">Дата платежа</th>
               <#-- <th scope="col">Получатель</th>-->
                <th scope="col">Сумма</th>
                <th scope="col">Валюта</th>
                <th scope="col">Статус</th>
             <#--   <th scope="col">Примечание</th>-->
            </tr>
            </thead>
            <tbody>
            <#list paymentList as payment>
                <tr>
                    <th scope="row">${payment.id}</th>
                    <td>${payment.paymentDateTime}</td>
                    <td>${payment.summa}</td>
                    <td>${payment.currency}</td>
                    <td>${payment.status}</td>
             <#--       <td>${payment.payment_id}</td>
                    <td>${payment.payment_id}</td>-->
                </tr>
            </#list>
            </tbody>
        </table>

    </div>

</@c.page>