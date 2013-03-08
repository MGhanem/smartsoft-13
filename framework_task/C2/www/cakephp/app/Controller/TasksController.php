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

    public function deleteTask ($task_id) {
        echo $task_id;
        $this->Task->deleteAll(array('Task.task_id'  => $task_id));
        $this->Session->setFlash('Task has been deleted.');
        $this->redirect(array('action'=>'listTasks'));
    }

    public function deleteList () {
    		$id=$this->Checklist->list_id;
    		$this->Checklist->delete($id[ '1'], true);    	
    }

     public function checkSession(){
        if($this->request->isPost()){
        $username = $this->Session->read('user');

        //echo $username['User']['id'];
        if (!$username){
            $this->redirect(array('action' => 'loginfailure'));
            exit();
        }
        else {
            $results = $this->User->findByUserId($username);
            if(!$results) {
                $this->Session->delete('user');
                //$this->Session->setFlash('Please login first');
                $this->redirect(array('action' => 'index'));
                exit();
            }
            $this->set('user', $results['username']);
        }


    }}

    public function beforeFilter() {
        $this->checkSession();
    }

} ?>