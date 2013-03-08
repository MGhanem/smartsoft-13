<?php class SharedlistsController extends AppController {
    public $helpers = array('Html', 'Form');

    public function shareListForm ($listID) {
    	$this->set('listID', $listID);
    }

    public function shareList() {
    	if ($this->request->is('post')) {
    		$record = $this->Sharedlist->findByUsernameAndListId($this->request->data['user_name'], intval($this->request->data['list_id']));
    		if (empty($record)) {
    			$this->Sharedlist->create();
            	$this->Sharedlist->set('username', $this->request->data['user_name']);
            	$this->Sharedlist->set('list_id', $this->request->data['list_id']);
            	$this->Sharedlist->save();
                $this->redirect(array('controller' => 'Checklists', 'action' => 'home'));
        	} else {
        		$this->Session->SetFlash('This list is already shared with this user');
        		$this->redirect(array('controller' => 'Checklists', 'action' => 'home'));
        	}
    	}
    }

} ?>