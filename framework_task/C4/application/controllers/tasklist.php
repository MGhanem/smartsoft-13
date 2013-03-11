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

	public function share_list($list_id)
	{	
		$user_id = $this->session->userdata('user_id');
	    $task = new Task_model();
	    $task->where('list_id', $list_id)->get();
	    $list = new List_model($list_id);
	    if(!$list->exists()) 
	    {
	      redirect('/tasklist/viewall');
	      return;
	    }
	    if($user_id !== False) 
	    {
	      $user = new User_model($user_id);
	      if($list->owner_id != $user_id && !$list->shared_with($user_id)) {
	        redirect('/tasklist/viewall');
	        return;
	      }
	    }
	    else 
	    {
	      redirect('/authentication/signin/');
	      return;
	    }
	    if($this->input->post('share') !== False)
	    {
	    	$user_name = $this->input->post('share');
	    	$share_user = new User_model();
	    	$share_user->where('username', $user_name)->get();
	    	if($list->shared_with($share_user->id) 
	    		|| $list->is_list_owner($share_user->id)
	    		|| !$share_user->exists()){
			    redirect('tasklist/viewall');
    			return;
	    	}
	    	if($list->save(array("shared_owner"=>$share_user)))
	    	{
	    		$data["title"] = 'Lists';
			    $data['username'] = $user->username;
			    $data["list"] = $list;
			    $data["task"] = $task;
			    $this->load->view('header', $data);
    			$this->load->view('single_list.php', $data);
	    	}
	    }
	}

	public function delete_share($shared_user_id, $list_id)
	{
		$user_id = $this->session->userdata('user_id');
	    $task = new Task_model();
	    $task->where('list_id', $list_id)->get();
	    $list = new List_model($list_id);
	    if(!$list->exists()) 
	    {
	      redirect('/tasklist/viewall');
	      return;
	    }
	    if($user_id !== False) 
	    {
	      $user = new User_model($user_id);
	      if($list->owner_id != $user_id && !$list->shared_with($user_id)) {
	        redirect('/tasklist/viewall');
	        return;
	      }
	    }
	    else 
	    {
	      redirect('/authentication/signin/');
	      return;
	    }
		$shared_user = new User_model($shared_user_id);
		if($list->shared_with($shared_user_id)){
			$list->delete(array('shared_owner'=>$shared_user));
			$data["title"] = 'Lists';
		    $data['username'] = $user->username;
		    $data["list"] = $list;
		    $data["task"] = $task;
		    $this->load->view('header', $data);
			$this->load->view('single_list.php', $data);
		}
		else{
			redirect('/tasklist/viewall');
			return;
		}
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
      $this->load->view('header',$data);
      $this->load->view('list_edit', $data);
    }
  }

}
?>
