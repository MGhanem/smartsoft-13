<?php

class User_model extends DataMapper {
  
  var $table="users";

 
  
  
  

  public function __construct($id=Null) {
    parent::__construct($id);
  }
  
}

?>
