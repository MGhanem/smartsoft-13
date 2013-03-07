<?php
class Tasklist extends CI_Controller {

  public function __construct() {
    parent::__construct();
    $this->load->helper('url');
  }

	public function index()
	{
		$this->viewAll();
	}

	public function create()
	{
		$user_id = $this->session->userdata('user_id');
		$user = new User_model;
		$user->where('id', $user_id)->get();
		
    
   
   
    if($this->input->post('name') !== False) {
      $list = new List_model();
      $list->name = $this->input->post('name');
      $list->save(array("owner"=>$user));
      $this->viewAll();
      

    } else {
     
      $data["title"] = 'New list';
      $data['username'] = $user->username;
      $this->load->view('header', $data);
      $this->load->view('list_create', $data);
    }
	}

	public function viewAll(){
		$list = new List_model();
		$user_id = $this->session->userdata('user_id');
		if($user_id != FALSE){
		$list->where('owner_id', $user_id)->get();
		    $user = new User_model;
		    $user->where('id', $user_id)->get();
		    $data["title"] = 'Lists';
        $data['username'] = $user->username;
        $data["list"] = $list;
        $this->load->view('header', $data);
        $this->load->view('all_lists.php', $data);
        }
        else {
      redirect('/authentication/signin/');
      return;
    }
        
        
       
        
	}

	public function view($listID){
		$list = new List_model();
		$task = new Task_model();
		$list->where('id', $listID)->get();
		$task->where('list_id', $listID)->get();
		$user = new User_model;
		$user_id = $this->session->userdata('user_id');
		$user->where('id', $user_id)->get();
		
		if($list->owner_id != $user_id && !$list->shared_with($user_id)) {
        redirect('/tasklist/viewall');
        return;
      }
		$data["title"] = 'Lists';
    $data['username'] = $user->username;
		$data["list"] = $list;
		$data["task"] = $task;
		
		
		
		$this->load->view('header', $data);
    $this->load->view('single_list.php', $data);
	}

	
	public function delete($listID)
	{	
		$list = new List_model();
		$list->get_by_id($listID);
		$list->delete();
		$this->viewAll();
	}

	

	public function share_list($user_name, $list_id)
	{
		$list = new List_model();
		$user = new User_model();
		$list->where('id', $list_id)->get();
		$user->where('username',$user_name)->get();
		if(empty($user->id)){
			echo 'Sorry! User not registered';
		}
		else{
			$list->save(array('shared_owner'=>$user));
			echo 'Share Successful';
		}
	}

	public function delete_share($user_name, $list_id)
	{
		$list = new List_model();
		$user = new User_model();
		$user->where('username',$user_name)->get();
		$list->where('id', $list_id)->get();
		$list->delete(array('shared_owner'=>$user));
		echo 'Deletion Successful';
	}

  public function edit($list_id) {
    $user_id = $this->session->userdata('user_id');
    $list = new List_model($list_id);
    if(!$list->exists()) {
      redirect('/tasklist/viewall');
      return;
    }
    if($user_id !== False) {
      $user = new User_model($user_id);
      if($list->owner_id != $user_id && !$list->shared_with($user_id)) {
        redirect('/tasklist/viewall');
        return;
      }
    } else {
      redirect('/authentication/signin/');
      return;
    }

    if($this->input->post('name') !== False) {
      $list->name = $this->input->post('name');
      $list->save();
      redirect("/tasklist/view/$list_id");
    } else {
      $data['list'] = $list;
      $data["username"] = $user->username;
      $data["title"] = 'Edit a list';
      $this->load->view('list_edit', $data);
    }
  }

}
?>
