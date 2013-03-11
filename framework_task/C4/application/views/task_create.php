  <div class="container">
  	<form action="/index.php/task/create/<?php echo $list_id; ?>" method="post">
   	<legend>New Task</legend>
   	<label style="display:inline;">Task:</label>
   	<div class="input-append">
   		<input type="text" name="text" value="" />
   		<input class="btn" type="submit" name="submit" value="Add Task" />
   	</div>
   	<input type="hidden" name="list_id" value="<?php echo $list_id; ?>" />
  	</form>
  	</div>
</body>
</html>