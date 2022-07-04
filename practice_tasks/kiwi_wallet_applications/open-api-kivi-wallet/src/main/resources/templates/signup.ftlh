<#import "parts/common_main.ftlh" as c>
<@c.page>

    <div class="container">
        <div class="card">
            <h5 class="card-header">Регистрация нового пользователя Kivi-кошелька</h5>

            <form>
                <div class="form-group">
                    <label for="exampleInputEmail1">Email</label>
                    <input type="email" class="form-control" id="email" aria-describedby="emailHelp"
                           placeholder="Введите email">

                    <label for="exampleInputEmail1">Имя</label>
                    <input type="email" class="form-control" id="name" aria-describedby="emailHelp"
                           placeholder="Введите имя">

                    <label for="exampleInputEmail1">Фамилия</label>
                    <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                           placeholder="Введите фамилию">

                    <label for="exampleInputEmail1">Номер телефона</label>
                    <input type="phone" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                           placeholder="Введите номер телефона">

                    <label for="exampleInputEmail1">Дата рождения</label>
                    <input type="date" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                           placeholder="Введите вашу дату рождения в формате dd.mm.YYYY">

                </div>
                <button type="submit" class="btn btn-primary">Регистрация</button>
            </form>
        </div>
    </div>
</@c.page>