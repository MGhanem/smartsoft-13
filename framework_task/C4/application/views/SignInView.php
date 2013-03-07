<html>


<head> 

</head>

<Div align = 'right'>
<form method="GET" action="/index.php/authentication/signUp">
<span>Don't have an account?!!</span>
<button style="display:inline;" onClick = "" >SignUp</button>
</form>
</Div>

<Div align ='center'>
	<form method="POST" action="/index.php/authentication/signIn">
	<dl> 
	 <dt>UserName</dt>
	 <dd><input type="text" width:250px placeholder="name" name="username" style="display:inline;"></dd>

	 <dt>Password</dt>
	 <dd><input type="password" width:250px placeholder="password" name="userpassword" style="display:inline;"></dd>

	</dl>
      <button>SignIn</button>
	</form>
	
</Div>

</html>
