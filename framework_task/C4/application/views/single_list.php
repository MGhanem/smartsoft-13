<div class="container">
    <div class="row">
      <div class="pull-left">
        <h2 style='display:inline;'><?php echo $list->name; ?></h2>
        <a class="icon-edit"  href="/index.php/tasklist/edit/<?php echo $list->id; ?>"></a>
        </div>
        <div class="pull-right">
        <span>  
        <a class="btn btn-mini btn-danger" href="/index.php/tasklist/delete/<?php echo $list->id; ?>">
          <i class="icon-trash"></i>
        </a>
        </span>
      </div>
    </div>
  <br>
  <div>
  <?php
    foreach ($task as $Task_model) {?>
      <div class="row" style="padding:3px;">
        <?php echo '<div class="span12 pull-left">&nbsp' . $Task_model->text?>
        <a class="pull-left btn btn-mini" href="/index.php/task/mark_done/<?php echo 
        $Task_model->id;?>">
          <?php 
            if($Task_model->done == 0){
                echo '<i class="icon-remove"></i>';
             }else{
                echo '<i class="icon-ok"></i>';
             }
          ?>
        </a>
        <a class="pull-right">&nbsp<a>
        <a class="pull-right btn btn-mini btn-danger" href="/index.php/task/delete/<?php echo
        $Task_model->id;?>"><i class="icon-trash"></i></a>
        <a class="pull-right">&nbsp<a>
        <a class="pull-right btn btn-mini btn-success" href="/index.php/task/edit/<?php echo
        $Task_model->id;?>"><i class="icon-edit"></i></a>
        </div>
      </div>
  <?php }?>
  </div>

  <a href="/index.php/task/create/<?php echo $list->id;?>">Create New Task</a>

  <div>
      <legend>Shared Owners</legend>
      <form class="form" action="/index.php/tasklist/share_list/<?php echo $list->id; ?>" method="post">
        <label>Share list with</label>
        <div class="input-append">
          <input class="span11" 
              type="text" 
              name="share" 
              placeholder="Who are you sharing to?" />
          <button class="btn" type="submit">Share</button>
        </div>
      </form>
  </div>

  <div class="row">
  <?php
      $owners = $list->shared_owner->get();
      foreach ($owners as $User_model) {
              echo '<div class="span12 pull-left" style="padding:3px;">' . $User_model->username; ?>
              <a class="pull-right btn btn-mini btn-danger" href="/index.php/tasklist/delete_share/<?php echo
              $User_model->id;?>/<?php echo $list->id?>/"><i class="icon-trash"></i></a>
              </div>
    <?php }?>
 </div>
</div>

</body>
</html>
