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
	
	public function edit()
	{
		echo 'Hello World!';
	}
	
}
?>

