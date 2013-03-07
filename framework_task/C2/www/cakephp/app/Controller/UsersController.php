<?php class UsersController extends AppController {
    public $helpers = array('Html', 'Form');

    public function index() {
           
    }

    public function signup() {
        if ($this->request->is('post')) { //check if incoming request is Post
            if (strlen($this->request->data['password']) >= 8) { //check if password less than 8 characters
                if ($this->request->data['password'] === $this->request->data['passwordconf']) { //check that passwords match
                    $record = $this->User->findByUsername($this->request->data['username']);
                    if (empty($record)) { //check that username is not taken
                        $this->User->create();
                        if ($this->User->save($this->request->data)) {
                              $this->Session->setFlash('Welcome '.$this->request->data['username'].'!');
                              $this->Session->write('user', $this->request->data['username']);
                              $this->redirect(array('controller' => 'Lists', action => 'home'));
                        } else {
                            $this->Session->setFlash('malacious else');
                            $this->redirect(array('action' => 'signup'));
                        }
                    } else {
                        $this->Session->setFlash('Username taken');
                        $this->redirect(array('action' => 'signup'));
                    }
                } else {
                    $this->Session->setFlash('Passwords dont match');
                    $this->redirect(array('action' => 'signup'));
                }
            } else {
                $this->Session->setFlash('Password less than 8 characters');   
                $this->redirect(array('action' => 'signup'));
            }
        }
    }

    public function login() {
        if($this->request->isPost()){
            if ($this->User->findByUsernameAndPassword($this->request->data['username'],$this->request->data['password'])) {
                $this->Session->setFlash('Welcome '.$this->request->data['username'].'!');
                $this->Session->write('user', $this->request->data['username']);
                $this->redirect(array('controller' => 'Lists' , 'action' => 'home'));
            } else {
                $this->Session->setFlash('Incorrect username or password');
                $this->redirect(array('action' => 'index'));
            }
        }
    }


} ?>