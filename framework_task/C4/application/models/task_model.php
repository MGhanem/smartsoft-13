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
  
}

?>
