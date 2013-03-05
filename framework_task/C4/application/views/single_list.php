<html>
<head>
	<title>List</title>
</head>
<body>
	<form  action="/index.php/tasklist/viewall/">­
    <input type="Submit" value="Back">
    </form>


	<?php
		echo 'ID: ' . $list->id . '<br />';
        echo 'Name: ' . $list->name . '<br />';
        echo 'Owner ID: ' . $list->owner_id . '<br /><br />';
	?>

	<br>
	<h1>Tasks:</h1>
	<br>

	

	<?php

		

		foreach ($task as $Task_model)
        {
            echo 'ID: ' . $Task_model->id . '<br />';
            echo 'Text: ' . $Task_model->text . '<br />';?>


            <form style='display:inline;' action="/index.php/task/edit/<?php echo $Task_model->id;?>">­
		    <input type="Submit" value="Edit Task">
		    </form>

            <form style='display:inline;' action="/index.php/task/delete/<?php echo $Task_model->id;?>">­
		    <input type="Submit" value="Delete Task">
		    </form>

		    <form style='display:inline;' action="#">­
		    <input type="Submit" value="Mark task as Done ">
		    </form>

		    <br><br><br>
		    <?php
           

            
        }
	
     ?>




     <br>


	<form style='display:inline;' action="/index.php/task/create/<?php echo $list->id;?>">­
    <input type="Submit" value="Create New Task">
    </form>
	
	<form  action="/index.php/tasklist/delete/<?php echo $list->id;?>">­
    <input type="Submit" value="Delete List">
    </form>

    <br>
    
	
</body>
</html>