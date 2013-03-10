<?php

class Task_model extends DataMapper {
  var $table="tasks";

  var $has_one= array(
    'list'=> array(
      'class'=>'List_model',
      'other_field'=>'task')
    );
  
  var $validation = array(
    'text' => array(
      'rules' => array('required', 'trim')
    ),
  );

  public function __construct($id=Null) {
    parent::__construct($id);
  }

  public function mark_done()
  {
    if($this->done == 0)
    {
      $this->done = 1;
      $this->save();
    }else{
      $this->done = 0;
      $this->save();
    }
  }  
}

?>
