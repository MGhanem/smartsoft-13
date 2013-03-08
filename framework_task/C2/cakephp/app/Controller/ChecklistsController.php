<?php class ChecklistsController extends AppController {
    public $helpers = array('Html', 'Form');

    public function index(){
        
    }

    public function home() {
        $this->layout = 'loggedin';
        $this->set('home', 'cakephp/index.php/Checklists/home.ctp');
        $this->set('checklists', $this->Checklist->find('all'));
        $this->set('SessionID', $this->Session->read('user'));
    }

    public function checkSession() {
        if($this->request->isPost()){
            $username = $this->Session->read('user');

            if (!$username){
                $this->redirect(array('action' => 'loginfailure'));
                exit();
            } /*else {
                $results = $this->User->findByUserId($username);
                if(!$results) {
                    $this->Session->delete('user');
                    $this->redirect(array('action' => 'index'));
                    exit();
                }
                $this->set('user', $results['username']);
            }*/
        }
    }

    public function newList () {
        $id = $this->Session->read('user');
        if(!empty($id)) {
            $this->Checklist->create();
            $this->Checklist->set('user_id', $id);
            $this->Checklist->set('name', 'New List');
            $this->Checklist->save();
            $this->redirect(array('action' => 'home'));
        }
    }

    public function beforeFilter() {
        $this->checkSession();
    }

    public function logout() {
        $this->Session->destroy();
        $this->redirect(array('controller' => 'Users', 'action' => 'index'));
    }

    public function submitNewListName() {
        if ($this->request->is('post')) {
            $this->Checklist->read(null, $this->request->data['list_id']);
            $this->Checklist->set(array(
            'name' => $this->request->data['name'],
            ));
            $this->Checklist->save();
            $this->redirect(array("action" => "home"));           
        }
    }

    public function deleteList ($list_id) {
        $this->Checklist->deleteAll(array('Checklist.list_id'  => $list_id));
        $this->Session->setFlash('List deleted successfully!');
        $this->redirect(array('action'=>'home'));
    }

} ?>