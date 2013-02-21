	var clicks=0;
	var minutes=0;
	var seconds=0;
	var flag=0;
	function startTiming(){
		var nowTime=new Date();
		var min=nowTime.getMinutes();
		var sec=nowTime.getSeconds();
		min=checkTime(minutes);
		sec=checkTime(seconds);
		seconds+=1;
		if(sec==60){
			seconds=0;
			minutes+=1;
		}
		document.getElementById("clock").innerHTML=minutes+":"+seconds;
		t=setTimeout(function(){if(flag==1)return;
			startTiming();
		}
			,500);
		if(minutes==1){
			document.getElementById("update").innerHTML="done, you score is "+clicks+" clicks.";
			document.getElementById("button1").disabled = true;
			document.getElementById("clock").innerHTML="";
			flag=1;
		}
	}
	function checkTime(time){
		if(time<10){
			time=+"0";
		}
		return time;
	}
	function incrementCounter(){
		if(clicks==0){
			document.getElementById("update").innerHTML="click";
			startTiming();
		}
		if(seconds==30)document.getElementById("update").innerHTML="faster";
		if(seconds==40)document.getElementById("update").innerHTML="you're close";
		clicks+=1;
		//alert(clicks);
		document.getElementById("counter1").innerHTML="Counter:"+clicks;
		if(seconds==50)document.getElementById("update").innerHTML="You have 10 seconds to go, faster.";
	}
	function playAgain(){
		if(document.getElementById("button1").disabled==true){
			document.getElementById("button1").disabled=false;
			minutes=0;
			seconds=0;
			flag=0;
			clicks=0;
		}
	}