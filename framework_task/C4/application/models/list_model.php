<?php

class List_model extends DataMapper {
  
  var $table="lists";

  var $has_one = array(
  	'owner'=>array(
  		'class'=>'User_model',
  		'join_other_as'=>'owner',
  		'join_table'=>'lists')
  	);

  var $has_many = array(
  	'shared_owner'=>array(
  		'class'=>'User_model',
      'join_self_as' => 'user',
      'join_other_as' => 'list',
      'join_table' => 'lists_users',
  		'other_field' => 'shared_list',
  		'cascade_delete' => FALSE
  		),
  	'task'=>array(
  			'class'=>'Task_model', 
  			'other_field'=>'list')
  		);  
 
  
  

  public function __construct($id=Null) {
    parent::__construct($id);
  }
  
}

?>
