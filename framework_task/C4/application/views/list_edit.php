  <div class="container">
  	<form action="/index.php/tasklist/edit/<?php echo $list->id; ?>" method="post">
	<legend>Edit List Name </legend>
	<label style="display:inline;">List name:</label>
	<div class="input-append">
		<input type="text" name="name" value="<?php echo $list->name; ?>" />
		<input class="btn" type="submit" name="submit" value="Change Name" />
	</div>
	</form>
  </div>
</body>
</html>
