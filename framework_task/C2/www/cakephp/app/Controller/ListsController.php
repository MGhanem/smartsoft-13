<?php class ListsController extends AppController {
    public $helpers = array('Html', 'Form');

    public function index(){
        
    }

    public function home() {
        $this->layout = 'loggedin';
        $this->set('home', 'cakephp/index.php/Lists/home.ctp');
    }

    public function checkSession() {
        if($this->request->isPost()){
            $username = $this->Session->read('user');
            if (!$username){
                $this->redirect(array('action' => 'loginfailure'));
                exit();
            } else {
                $results = $this->User->findByUsername($username);
                if(!$results) {
                    $this->Session->delete('user');
                    $this->redirect(array('action' => 'index'));
                    exit();
                }
                $this->set('user', $results['username']);
            }
        }
    }

    public function beforeFilter() {
        $this->checkSession();
    }

    public function logout() {
        $this->Session->destroy();
        $this->redirect(array('controller' => 'Users', 'action' => 'index'));
    }
    
} ?>