<?php

class List_model extends DataMapper {
  
  var $table="lists";

  var $has_one = array('owner'=>array('class'=>'User_model','join_other_as'=>'owner', 'join_table'=>'lists'));
  var $has_many = array('shared_owner'=>array('class'=>'User_model',
  'other_field' => 'shared_lists', 'cascade_delete' => FALSE,
  'join_other_as'=>'shared_owner', 'join_self_as'=>'list', 'join_table' =>
  'list_shared_with_user'),
  'task'=>array('class'=>'Task_model', 'other_field'=>'list'));  

  public function __construct($id=Null) {
    parent::__construct($id);
  }

  public function shared_with($user_id) {
    $this->shared_owner->get();
    foreach($this->shared_owner as $owner) {
      if($owner->id == $user_id) {
        return True;
      }
    }
    return False;
  }
}

?>
