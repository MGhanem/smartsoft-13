<?php
class authentication extends CI_controller{
    
    public function __construct()
        {
             parent::__construct();
             $this->load->helper('url');
        }


    function index()
	{
		$this->load->view('SignInView');
	}

    public function signIn() {
         
        $u = new User_model();
        $userIn=$this->input->post('nameSign');
        $passwordIn=$this->input->post('passwordSign');
        if ($userIn !== False && $passwordIn !== False){
          $u->where('username', $userIn);
          $u->where('password', $passwordIn);
          $u->get();
          $userId = $u->id;
          $this->session->set_userdata('user_id', $userId);
          redirect('/tasklist/viewall');
        }
        else{
          $this->load->view('SignInView'); 
        }
    }
    

    public function signUp() {
         if ( ! isset($_POST['userName'])){
         $this->load->view('registerationView');
         } 
         else{
         $newUser = new User_model();
         $userNew=$this->input->post('userName');
         $passwordNew=$this->input->post('password');
         if ($userNew != "" & $passwordNew != ""){
         $newUser->username = $userNew;
         $newUser->password = $passwordNew;
         if($newUser->save()){
         	//echo'Congratulations! You have successfully registered to our system';
             $userId = $newUser->id;
             $this->session->set_userdata('user_id', $userId);
             echo $this->session->userdata('user_id');
             redirect('/tasklist/viewall');

         }
         else{
            echo'registeration failed .. please try registering again';
            $this->load->view('registerationView');
         }
        }
        else{
           echo 'Registeration Fields are empty!! .. please fill in all the fields and then try again';
           $this->load->view('registerationView'); 
            }
        }

    }

    public function signout() {
        $this->session->sess_destroy();

    }

}  
?>
