<?php
class authentication extends CI_controller{
    
    function index()
	{
		$this->load->view('registerationView');
	}

    public function signIn() {
          // $name, $password 
    }

    public function signUp() {
         // $name, $e-mail, $password, $confirmPassword
         $newUser = new User_model();
         $userNew=$this->input->post('userName');
         $passwordNew=$this->input->post('password');
         $passwordCheck = $this->input->post('passwordC');
         $newUser->username = $userNew;
         $newUser->password = $passwordNew;
         if($newUser->save()){
         	echo 'Esht3alat';
         }





    }

    public function signOut() {

    }

   /* public function _remap($method){
     if (($method == 'signIn') || ($method == 'signUp') || ($method == 'signOut') )
     {
         $this->$method();
     }
     else
     {
     	 show_404();
     }

 	}*/


}  
?>