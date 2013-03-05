<?php
class Task extends CI_Controller {

	public function index()
	{
		echo 'Hello World!';
	}
	
	public function create($text)
	{
		$task = new Task_model();
		$task->text = $text;
    if(true) {
      echo 'Hello World!';
    } else {
      echo 'test_failed';
    }
	}
	
	public function delete()
	{
		echo 'Hello World!';
	}
	
	//used to edit the text of a certain task within a list
	public function edit($taskID, $newTask)
	{
		$task = new Task_model();
		$task = get_by_id($taskID);
		$task->name = $newTask;
		echo 'successfully changed';
		//redirect('index.php/tasklist/viewAll');
	}

	//Marks a certain task as done
	public function mark_done($taskID)
	{
		$task = new Task_model();
		$task = get_by_id($taskID);
		if($task->done)
		{
			echo 'Already marked as done';
		}
		else
		{
			$task->done = 1;
			echo 'Task marked successfully';
		}
		//redirect('index.php/tasklist/viewAll');
	}


	
}
?>

