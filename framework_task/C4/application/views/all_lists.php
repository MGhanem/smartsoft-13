<html>
<head>
	<title>User's List</title>
</head>
<body>

	<?php 
	foreach ($list as $List_model)
        {?>

            <a href="/index.php/tasklist/view/<?php echo $List_model->id;?>"> <?php echo  $List_model->name . '<br /><br />';?></a>
            
       <?php
             }
     ?>

</body>
</html>