<?php
class Task extends CI_Controller {

  public function __construct() {
    parent::__construct();
    $this->load->helper('url');
  }

	public function index()
	{
		echo 'Hello World!';
	}
	
	public function create($list_id)
	{
    if($this->input->post('text') !== False) {
      $task = new Task_model();
      $task->text = $this->input->post('text');
      $list = new List_model($list_id);
      if($task->save(array('list'=>$list))) {
        redirect("/tasklist/view/$list_id");
      } else {
        echo 'Task not saved';
      }
    } else {
      $data["list_id"] = $list_id;
      $this->load->view('task_create', $data);
    }
	}
	
	public function delete($task_id)
	{
    $task = new Task_model($task_id);
    $task->delete();
    redirect('/tasklist/'.$task->list->id);
	}
	

	//used to edit the text of a certain task within a list
	public function edit($task_id)
	{
    $task = new Task_model($task_id);
    if($this->input->post('text') !== False) {
      $task->text = $this->input->post('text');
      if($task->save()) {
        redirect("/tasklist/view/".$task->list->id);
      } else {
        echo 'Task not saved';
      }
    } else {
      $data["task_id"] = $task_id;
      $data["text"] = $task->text;
      $this->load->view('task_edit', $data);
    }

	}
	//Marks a certain task as done
	public function mark_done($taskID)
	{
		$task = new Task_model();
		$task->where('id',$taskID)->get();
		if($task->done == 0)
		{
			//echo 'Task marked successfully';
			$task->done = 1;
			$task->save();
			return true;
		}
		return false;
	}

	public function viewAll(){
			$task = new Task_model();
	        $task->get();
	        $data["task"] = $task;
	        return $data;
		}


	
}
?>

