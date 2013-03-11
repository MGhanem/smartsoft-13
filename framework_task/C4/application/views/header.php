<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title><?php echo $title; ?></title>
    <link type="text/css" rel="stylesheet" href="/css/bootstrap-editable.css">
    <link type="text/css" rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/bootstrap-responsive.min.css">
</head>
<body>
	<div class="navbar">
		<div class="navbar-inner">
			<div class="pull-left">
				<h4>Welcome to To-Do!</h2>
			</div>
			<div class="pull-right">
				<?php if(isset($username)) { ?>
		  		<h4>Hello <?php echo $username; ?>, 
		  			<a href="/index.php/authentication/signout"> 
		  			Sign out 
		  			</a>
		  		</h4>
  				<?php } ?>
			</div>
		</div>
	</div>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-editable.js"></script>