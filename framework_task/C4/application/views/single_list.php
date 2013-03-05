<html>
<head>
	<title>List</title>
</head>
<body>
  <a href="/index.php/tasklist/viewall/">Back</a>
  <br />
	<h3><?php echo $list->name; ?></h3>
  <ul>
	<?php
		foreach ($task as $Task_model) {
            echo '<li>' . $Task_model->text?>
            <a href="/index.php/task/edit/<?php echo
            $Task_model->id;?>">edit</a>
            <a href="/index.php/task/delete/<?php echo
            $Task_model->id;?>">delete</a>
            </li>

  <?php }?>
  </ul>
  <a href="/index.php/task/create/<?php echo $list->id;?>">Create New Task</a>
  <br >
  <br >
	<form  action="/index.php/tasklist/delete/<?php echo $list->id;?>">­
    <input type="Submit" value="Delete List">
  </form>
</body>
</html>
