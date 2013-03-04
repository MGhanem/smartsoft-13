<?php

class List_model extends DataMapper {
  
  var $table="lists";

  var $has_one = array('owner'=>array('class'=>'User_model','join_other_as'=>'owner_id', 'join_table'=>'lists'));
  var $has_many = array('shared_owner'=>array('class'=>'User_model',
  'other_field' => 'shared_lists', 'cascade_delete' => FALSE),
  'task'=>array('class'=>'Task_model', 'other_field'=>'list'));  
 
  
  

  public function __construct($id=Null) {
    parent::__construct($id);
  }
  
}

?>
