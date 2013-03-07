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
        if($_SERVER['REQUEST_METHOD'] == "GET"){
           $this->load->view('SignInView'); 
        } 
        else{
        $user = new user_model();
        $username=$this->input->post('username');
        $userpassword=$this->input->post('userpassword');
        if ($username !== "" && $userpassword !== ""){
          $user->where('username', $username);
          $user->where('password', $userpassword);
          $user->get();
          if($user->exists()){
          $userId = $user->id;
          $this->session->set_userdata('user_id', $userId);
          redirect('/tasklist/viewall');
          }
          else{
            echo'Your username or password seems to be wrong .. please try again.';
            $this->load->view('SignInView');
          }
        }
        else{
          echo'Fileds are empty .. please try again.';
          $this->load->view('SignInView'); 
            }
        }
    }
    

    public function signUp() {

         if($_SERVER['REQUEST_METHOD'] == "GET"){
          $this->load->view('registerationView');  
         }
         else{
         $user = new user_model();
         $username=$this->input->post('username');
         $userpassword=$this->input->post('userpassword');
         if ($username !== "" && $userpassword !== ""){
         $user->username = $username;
         $user->password = $userpassword;
         if($user->save()){
         	//echo'Congratulations! You have successfully registered to our system';
             $userId = $user->id;
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
        $this->load->view('SignInView');

    }

}  
?>
