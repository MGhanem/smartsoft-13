<?php

class User_model extends DataMapper{

	var $table="users";

	public function __construct($id=null) {
		parent::__construct($id);
	}

}

?>