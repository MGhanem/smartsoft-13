<?php class TasksController extends AppController {
    public $helpers = array('Html', 'Form');

    public function listTasks ($id, $name) {
    	$this->layout = 'loggedin';
    	$this->set('tasks', $this->Task->find('all'));
    	$this->set('ListID', $id);
    	$this->set('TaskName', $name);
    }

    public function editListName($id) {
    	$this->layout = 'loggedin';
    	$this->set('listId', $id);
    }
} ?>