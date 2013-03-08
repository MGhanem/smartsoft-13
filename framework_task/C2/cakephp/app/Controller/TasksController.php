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
    	$this->set('list_id', $id);
       // $this->redirect(array('controller' => 'checklists', 'action' => 'submitNewListName', $id, $this->request->data['listName']));
    }

        public function uncheck($task_id, $ListID, $TaskName) {
        $this->Task->read(null, $task_id);
        $this->Task->set('checked', '0');
        $this->Task->save();
        $this->redirect(array('action'=>'listTasks', $ListID, $TaskName));
    }

    public function check($task_id, $ListID, $TaskName) {
        $this->Task->read(null, $task_id);
        $this->Task->set('checked', '1');
        $this->Task->save();
        $this->redirect(array('action'=>'listTasks', $ListID, $TaskName));
    }

    public function deleteTask ($task_id, $list_id, $list_name) {
        $this->Task->deleteAll(array('Task.task_id'  => $task_id));
        $this->Session->setFlash('Task has been deleted.');
        $this->redirect(array('action'=>'listTasks', $list_id, $list_name));
    }

    public function deleteList () {
            $id=$this->Checklist->list_id;
            $this->Checklist->delete($id[ '1'], true);      
    }

    public function newtask () {
        $this->layout = 'loggedin';
        $this->Task->create();
        $this->Task->set('list_id', $this->request->data['list_id']);
        $this->Task->set('content', $this->request->data['content']);
        $this->Task->save();
        $this->Session->setFlash('task added');
        $this->redirect(array('action' => 'listTasks' , $this->request->data['list_id'], $this->request->data['list_name']));
    }

    public function newtaskform($id,$name) {
        $this->layout = 'loggedin';
        $this->set('list_id', $id);
        $this->set('list_name', $name);
    }

    public function edittask($task_id,$id,$name) {
        $this->layout = 'loggedin';
        $this->set('task_id', $task_id);
        $this->set('list_id', $id);
        $this->set('list_name', $name);
    }

    public function edittasksave() {
        $this->layout = 'loggedin';
        if ($this->request->is('post')) {
            $this->Task->read(null, $this->request->data['task_id']);
            $this->Task->set(array(
            'content' => $this->request->data['content'],
            ));
            $this->Task->save();
            $this->redirect(array('action' => 'listTasks' , $this->request->data['list_id'], $this->request->data['list_name']));           
        }
    }

     /*public function checkSession(){
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
    }*/
} ?>