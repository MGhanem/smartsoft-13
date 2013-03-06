<?php

class User_model extends DataMapper {
  
  var $table="users";

  var $has_many = array(
  	'shared_list'=> array(
  		'class'=>'List_model',
      'join_self_as' => 'list',
      'join_other_as' => 'user',
      'join_table' => 'lists_users',
  		'cascade_delete' => FALSE,
  		'other_field' => 'shared_owner'),
  	'owns_lists'=>array(
  		'class'=>'List_model',
  		'cascade_delete' => FALSE,
  		'other_field' => 'owner')
  	); 

  public function __construct($id=Null) {
    parent::__construct($id);
  }
  
}

?>
