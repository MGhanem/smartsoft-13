<?php class TasksController extends AppController {
    public $helpers = array('Html', 'Form');

    public function listTasks () {
    	$this->layout = 'loggedin';
    }
} ?>