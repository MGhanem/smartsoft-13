<html>


<head> 
<h1> Welcome to the best online Task Manager </h1>
</head>

<Div align = 'right'>
<form action="/index.php/authentication/signUp">
<span>Don't have an account?!!</span>
<button style="display:inline;" onClick = "" >SignUp</button>
</form>
</Div>

<Div align ='center'>
	<form method="POST" action="/index.php/authentication/signIn">
	<dl> 
	 <dt>UserName</dt>
	 <dd><input type="text" width:250px placeholder="name" name="nameSign" style="display:inline;"></dd>

	 <dt>Password</dt>
	 <dd><input type="password" width:250px placeholder="password" name="passwordSign" style="display:inline;"></dd>

	</dl>
      <button>SignIn</button>
	</form>
	
</Div>

</html>
