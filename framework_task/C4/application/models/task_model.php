<?php

class Task_model extends DataMapper {
  $table="tasks";
  var $has_one('list');
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
