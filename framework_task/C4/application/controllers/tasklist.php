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

	public function create($listName, $ownerID)
	{
		$list = new List_model();
    $list-> name = $listName;
    $list-> owner_id= $ownerID;
    $list-> save();
    $this->viewAll();
	}

	public function viewAll(){
		$list = new List_model();
        $list->get();
        $data["list"] = $list;
        $this->load->view('all_lists.php', $data);
	}

	public function view($listID){
		$list = new List_model();
		$task = new Task_model();
		$list->where('id', $listID)->get();
		$task->where('list_id', $listID)->get();
		$data["list"] = $list;
		$data["task"] = $task;
    $this->load->view('single_list.php', $data);
	}

	
	public function delete($listID)
	{	
		$list = new List_model();
		$list->get_by_id($listID);
		$list->delete();
		$this->viewAll();
	}

	public function deleteAll(){
		$list = new List_model();
        $list->get();
       	$list->delete_all();
       	$this->viewAll();

	}

  public function edit($list_id) {
    $user_id = $this->session->userdata('user_id');
    $list = new List_model($list_id);
    if(!$list->exists()) {
      redirect('/tasklist/viewall');
      return;
    }
    if($user_id !== False) {
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
      $this->load->view('list_edit', $data);
    }
  }
}
?>
