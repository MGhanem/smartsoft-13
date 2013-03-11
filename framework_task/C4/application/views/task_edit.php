	<div class="container">
		<form action="/index.php/task/edit/<?php echo $task_id; ?>" method="post">
		<legend>Edit Task </legend>
		<label style="display:inline;">Task:</label>
		<div class="input-append">
			<input type="text" name="text" value="<?php echo $text; ?>" />
			<input class="btn" type="submit" name="submit" value="Change Task" />
		</div>
		</form>
	</div>	
</body>
</html>