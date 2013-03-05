<?php
class authentication extends CI_controller{
    
    public function __construct()
        {
             parent::__construct();
             $this->load->library('session');
        }


    function index()
	{
		$this->load->view('SignInView');
	}

    public function signIn() {
         
        $u = new User_model();
        $userIn=$this->input->post('nameSign');
        $passwordIn=$this->input->post('passwordSign');
        if ($userIn != "" & $passwordIn != ""){
        $u->where('username', $userIn);
        $u->where('password', $passwordIn);
        $u->get();
        // Remove the next echo and add redirection to the following page
        echo $u->id;
        $userId = $u->id;
        $this->session->set_userdata('user_id', $userId);
        }
        else{
           $this->load->view('SignInView'); 
        }
    }
    

    public function loadReg(){
             $this->load->view('registerationView');
    }

    public function signUp() {
         $newUser = new User_model();
         $userNew=$this->input->post('userName');
         $passwordNew=$this->input->post('password');
         if ($userNew != "" & $passwordNew != ""){
         $newUser->username = $userNew;
         $newUser->password = $passwordNew;
         if($newUser->save()){
         	echo'Congratulations! You have successfully registered to our system';
         }
         else{
            echo'registeration failed .. please try registering again';
         }
        }
        else{
           echo 'Registeration Fields are empty .. please try again'; 
        }

    }

    public function signOut() {
        $this->session->sess_destroy();

    }

}  
?>