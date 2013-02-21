
function AlertIt() {  
alert("Sorry You don't have the permission to access Nourhan's friends"); 
}
function sendCheck()
{
  var msgBox = document.getElementById('message');
  var sender = document.getElementById('senderName');
  if(msgBox.value == "" && sender.value == ""){
     alert("Nothing to send .. You wrote nothing!!");
  }
  if(msgBox.value != "" && sender.value == ""){
      alert("Please enter your name before sending the message");
  }
  if(msgBox.value == "" && sender.value != ""){
      alert("Please enter your message!!");
  }
  if(msgBox.value != "" && sender.value != ""){
      alert("Your message was sent successfully ;)");
  }
  

}
