<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<title>
		Lists R US
	</title>
	<?php
		echo $this->Html->meta('icon');

		echo $this->Html->css('home');

		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->fetch('script');
	?>
</head>
<body>
	<header>
		<div class="nav">
			<h2><?php echo $this->Html->link('Lists R Us', array('controller' =>'Checklists', 'action' => 'home')) ?></h2>
			<span><?php echo $this->Html->link('logout', array('controller' =>'Checklists', 'action' => 'logout')); ?></span>
		</div>
	</header>
	<div id="container">
			<?php echo $this->Session->flash(); ?>

			<?php echo $this->fetch('content'); ?>
	</div>
</body>
</html>
