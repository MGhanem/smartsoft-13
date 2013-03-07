<h3>  Availble Lists:</h3>

	<?php 
	$c = 0;
		foreach ($list as $List_model)
        {
        	$c++;?>
        	<li>
          <a href="/index.php/tasklist/view/<?php echo $List_model->id;?>"> <?php echo  $List_model->name . '<br /><br />';?></a></li>
            <?php
            
        }
        if($c==0){
        	echo 'This user has no lists.';
        }
        ?>
     <br>
      <br>
     <a href="/index.php/tasklist/create/">Create New List</a>
     </body>
</html>
