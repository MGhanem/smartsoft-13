  <form action="/index.php/task/create/<?php echo $list_id; ?>" method="post">
   <span>Task: </span>
   <input type="text" name="text" value="" />
   <input type="hidden" name="list_id" value="<?php echo $list_id; ?>" />
   <input type="submit" name="submit" value="Add Task" />
  </form>
</body>
</html>
