  <form action="/index.php/task/edit/<?php echo $task_id; ?>" method="post">
   <span>Task: </span>
   <input type="text" name="text" value="<?php echo $text; ?>" />
   <input type="submit" name="submit" value="Change Task" />
  </form>
</body>
</html>
