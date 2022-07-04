<#import "parts/common_main.ftlh" as c>
<@c.page>
    <div class="container">
        <h4>Войти в личный кабинет</h4>
    </div>
    <br/>
    <div class="container">

        <form>
            <div class="form-group">
                <label for="exampleInputEmail1">Email address</label>
                <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                       placeholder="Enter email">
                <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                       placeholder="Enter password">
            </div>
            <button type="submit" class="btn btn-primary">Вход</button>
        </form>

    </div>
</@c.page>