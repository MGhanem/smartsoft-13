<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit your task</title>
</head>
<body>
  <form action="/index.php/task/edit/<?php echo $task_id; ?>" method="post">
   <span>Task: </span>
   <input type="text" name="text" value="<?php echo $text; ?>" />
   <input type="submit" name="submit" value="Change Task" />
  </form>
</body>
</html>
