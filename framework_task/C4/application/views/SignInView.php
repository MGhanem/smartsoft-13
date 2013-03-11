<html>
<head> 
	<title>Welcome to To-Do!</title>
	<link type="text/css" rel="stylesheet" href="/css/bootstrap-editable.css">
    <link type="text/css" rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
</head>
<body>
	<div class="navbar">
		<div class="navbar-inner">
			<div class="pull-left">
				<h4>Welcome to To-Do!</h4>
			</div>
				<form id="signup" method="GET" action="/index.php/authentication/signUp">
				<div class="pull-right">
					<h6 style="display:inline;">Don't have an account?!!</h6>
					<a type="submit" onclick="document.getElementById('signup').submit();">SignUp</a>
				</div>
				</form>
		</div>
	</div>

	<div class="container">
		<div class="row">
			<div class="span5 offset3">
				<form class="form-horizontal" method="POST" action="/index.php/authentication/signIn">
					<div class="control-group">
						<label class="control-label" for="user_name">UserName:</label>
						<div class="controls">
							<input id="user_name" type="text" name="username" placeholder="Username..."/>		
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="user_pass">Password:</label>
						<div class="controls">
							<input id="user_pass" type="password" name="userpassword" placeholder="Password..."/>		
						</div>
					</div>
			    	<div class="controls">
			    		<button type="submit" class="btn">Sign in</button> 
			    	</div> 
			  	</form>
		  	</div>
		</div>
	</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-editable.js"></script>
</body>
</html>
