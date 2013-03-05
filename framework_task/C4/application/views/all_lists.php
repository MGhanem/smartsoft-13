<html>
<head>
	<title>User's List</title>
</head>
<body>

	<?php 
	$c = 0;
		foreach ($list as $List_model)
        {
        	$c++;

        ?>

            <a href="/index.php/tasklist/view/<?php echo $List_model->id;?>"> <?php echo  $List_model->name . '<br /><br />';?></a>
            
       <?php
        }
        if($c==0){
        	echo 'This user has no lists.';
        }
        else{
        	?>
        	<form action="/index.php/tasklist/deleteall/">
		    <input type="Submit" value="Delete all lists">
		    </form>

		    <?php
        }
		
	
	
	
     ?>

     




   
    


     

</body>
</html>