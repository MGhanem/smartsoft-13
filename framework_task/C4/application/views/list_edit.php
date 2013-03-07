<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit your list</title>
</head>
<body>
  <form action="/index.php/tasklist/edit/<?php echo $list->id; ?>" method="post">
   <span>Name: </span>
   <input type="text" name="name" value="<?php echo $list->name; ?>" />
   <input type="submit" name="submit" value="Change Name" />
  </form>
</body>
</html>
