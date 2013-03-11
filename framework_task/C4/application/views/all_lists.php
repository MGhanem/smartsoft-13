  <div class="container">
    <legend>Availble Lists:</legend>
    <ol>
    <?php 
    $c = 0;
      foreach ($list as $List_model)
      {
        $c++;?>
        <li>
        <a href="/index.php/tasklist/view/<?php echo $List_model->id;?>"> <?php echo  $List_model->name . '<br /><br />';?></a>
        </li>
        <?php 
      }
      if($c==0){
        echo '<div class="alert alert-info">You still dont have any lists!</div>';
      }
      ?>
    </ol>
    <a class="btn" href="/index.php/tasklist/create/">Create List</a>
  </div>
</body>
</html>
