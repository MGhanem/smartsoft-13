<?php

class User_model extends DataMapper {
  
  var $table="users";

  var $has_many = array(
  	'shared_lists'=>array(
  		'class'=>'List_model',
  		'cascade_delete' => FALSE,
  		'other_field' => 'shared_owner',
  		'join_self_as'=>'user',
  		'join_other_as'=>'list',
  		'join_table' => 'lists_users'),
 	'owned_lists'=>array(
 		'class'=>'List_model',
 		'cascade_delete' => FALSE,
 		'other_field' => 'owner')
 	); 


  
  

  public function __construct($id=Null) {
    parent::__construct($id);
  }
  
}

?>
