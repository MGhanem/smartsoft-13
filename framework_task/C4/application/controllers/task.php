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
        echo "Task saved with id $task->id!";
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
	
	public function edit($task_id)
	{
    $task = new Task_model($task_id);
    if($this->input->post('text') !== False) {
      $task->text = $this->input->post('text');
      if($task->save()) {
        echo "Task saved with id $task->id!";
      } else {
        echo 'Task not saved';
      }
    } else {
      $data["task_id"] = $task_id;
      $data["text"] = $task->text;
      $this->load->view('task_edit', $data);
    }
	}
	
}
?>

