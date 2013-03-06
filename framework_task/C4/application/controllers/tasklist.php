<?php
class Tasklist extends CI_Controller {

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
	    $list = new List_model($list_id);
	    if($this->input->post('name') !== False) {
	      $list->name = $this->input->post('name');
	      $list->save();
	      redirect("/tasklist/$list_id");
	    } else {
	      $data['list'] = $list;
	      $this->load->view('list_edit', $data);
	    }
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
}
?>
