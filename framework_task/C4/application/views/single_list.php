<html>
<head>
	<title>List</title>
</head>
<body>
  <a href="/index.php/tasklist/viewall/">Back</a>
  <br />
  <br />
	<h3 style='display:inline;'><?php echo $list->name; ?></h3>
  <span>
    <a href="/index.php/tasklist/edit/<?php echo $list->id; ?>">edit name</a>
  </span>
  <ul>
	<?php
		foreach ($task as $Task_model) {
            if($Task_model->done == 0){
                $is_done = "mark_done";
             }else{
                $is_done = "unmark";
             } 

            echo '<li>' . $Task_model->text?>
            <a href="/index.php/task/edit/<?php echo
            $Task_model->id;?>">edit</a>
            <a href="/index.php/task/delete/<?php echo
            $Task_model->id;?>">delete</a>
            <a href="/index.php/task/mark_done/<?php echo 
            $Task_model->id;?>"><?php echo $is_done ?></a>
            </li>
  <?php }?>
  </ul>
  <a href="/index.php/task/create/<?php echo $list->id;?>">Create New Task</a>
  <br >
  <br >
  <form action="/index.php/tasklist/delete/<?php echo $list->id;?>">
    <input type="Submit" value="Delete List">
  </form>
  <h3>Shared Owners:</h3>
  <form action="/index.php/tasklist/share_list/<?php echo $list->id; ?>" method="post">
    <span>Share list with: </span>
    <input type="text" name="share" value="<?php echo $text; ?>" />
    <input type="submit" name="submit" value="Share"/>
  </form>
  <ul>
  <?php
      $owners = $list->shared_owner->get();
      foreach ($owners as $User_model) {
              echo '<li>' . $User_model->username; ?>
              <a href="/index.php/tasklist/delete_share/<?php echo
              $User_model->id;?>/<?php echo $list->id?>/">delete</a>
              </li>
    <?php }?>
 </ul>
</body>
</html>
