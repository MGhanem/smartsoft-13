<?php
class Tasklist extends CI_Controller {

	public function index()
	{
		
		
	}
	
	public function create($listName, $ownerID)
	{
		$list = new List_model();
        $list-> name = $listName;
        $list-> owner_id= $ownerID;
        $list-> save();
      


       
        
	}

	public function viewAll(){
		$list = new List_model();
        $list->get();
        $data["list"] = $list;
        $this->load->view('all_lists.php', $data);
       	

		

	}

	public function view($listID){
		$list = new List_model();
		$list->where('id', $listID)->get();

		$data["list"] = $list;
        $this->load->view('single_list.php', $data);



		
	}

	
	public function delete($listID)
	{	

		
		$list = new List_model();
		$list->get_by_id($listID);
		$list->delete();


	}
	
	
	
}
?>