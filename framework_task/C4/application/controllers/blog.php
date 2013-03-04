<?php
class Blog extends CI_Controller {
   
   public function index() {
   		echo'Hello World!';
    }

    public function comments(){
    	echo'AHLAN'; 
    	
    }

    public function again(){
    	echo'Bonjour!!!!';
    }

    public function tryIt(){
    	echo'Remapping was used successfully';
    }

    public function _remap($method){
     if (($method == 'comments') || ($method == 'again'))
     {
         $this->$method();
     }
     else
     {
         $this->tryIt();
     	 //show_404();
     }

 	}
    
    
}

?>