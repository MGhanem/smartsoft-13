    <div class="welcome">
        <img src="/cakephp/app/webroot/img/checklist.jpg" width="400px" height="400px;">
        <div class="login">
            <form name="login" method="post" action="/cakephp/index.php/Users/login">
                <fieldset>
                    <legend>Login</legend>
                    <label>
                        Username:
                        <input name="data[username]" type="text" placeholder="username">
                    </label>
                    <label>
                        Password:
                        <input name="data[password]" type="password" placeholder="password">
                    </label>
                </fieldset>
                <input type="submit" value="Login">
            </form>
        </div>
        <div class="signup">
            <form name="signup" method="post" action="/cakephp/index.php/Users/signup">
                <fieldset>
                    <legend>Signup</legend>
                    <label>
                        Username:
                        <input name="data[username]" type="text" placeholder="username">
                    </label>
                    <label>
                        Password:
                        <input name="data[password]" type="password" placeholder="password">
                    </label>
                    <label>
                        Confirm password:
                        <input name="data[passwordconf]" type="password" placeholder="password">
                    </label>
                </fieldset>
                <input type="submit" value="Sign up">
            </form>
        </div>
    </div>