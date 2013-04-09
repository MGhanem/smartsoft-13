var dimension = 10;
var table;
var cells;
var levelTitle;
var buttonArray = new Array();
var wordsArray = [];
var pauseFlag = true;
var gameOver = false;
var level = 1;
var droppingBlocks;
var pullingBlocks;
var suspenseTimer;
var blockId = 0;
var Time = 1000;
var newTime = Time - 800;
var numberOfCalls = 0;
var wordExistsInArray = new Array();
var bigTower = '';
var lang;
var successfulWords = [];
var win = true;
var score = 0;
var gameButtonClear;
var gameButtonRestart;
var gameOverPopUp;


function newGame(){
	$('.zone').empty();
	setButtons();
	$('.zone').append('<div><table class="table1" id="main-table"></table></div>' +
	'<div id="list-div" class="well" style=""><ol id="wordsList"></ol>' + 
	'<div class="label-div"><label id="wordLabel" class="label1"></label></div></div>'+
	'<br><br><div style="float: right;width: 220px;"><h3 id="score">SCORE: ' + score + '</h3></div>' + 
	'<div class="buttons-div">' + gameButtonClear + gameButtonRestart +'</div>'+
	'<div id ="level-popup" style="font-size: 1400%; color: white; position: absolute; margin-top: 120px;"> LEVEL ' + level  +'</div>');
	$.ajaxSetup({async: false});
	$('#level-popup').fadeTo(0,0);
	$('#level-popup').fadeTo(1500,1);
	$('#level-popup').fadeTo(1500,0);
	setTimeout(function(){
		$('#level-popup').remove();
		startGame();
	}, 3500);
}
function startGame(){
	levelTitle = $('#level');
	table = $('#main-table');
	list = $('#wordsList');
	cells = table.find('td');
	buttons = table.find('button');
	setLevelAttributes(level);
	
}
function initializeGame(){
	var trHtml = [];
	var letter;
	for(var y = 0; y < dimension; y++){
		trHtml.push('<tr class="row');
		trHtml.push(y);
		trHtml.push('">');
			for(var x = 0; x < dimension; x++){
				if(y > dimension - 4){
					trHtml.push('<td style="min-width:50; max-width:50;" id="col');
					trHtml.push(y);
					trHtml.push('-');
					trHtml.push(x);
					trHtml.push('"><button onclick="callMethods(this.id)" class="btn btn-inverse" id="button');
					trHtml.push(y);
					trHtml.push('-');
					trHtml.push(x);
					trHtml.push('">');
					letter = generateLetter();
					trHtml.push(letter);
					trHtml.push('</button></td>');
				}
				else{
					trHtml.push('<td style="min-width:50; max-width:50;" id="col');
					trHtml.push(y);
					trHtml.push('-');
					trHtml.push(x);
					trHtml.push('"></td>');
				}
			}
		
			trHtml.push('</tr>');
	}
	trHtml = trHtml.join('');
	table.append($(trHtml));
	l = setLevelTitle();
	$('#level').append(levelTitle);
}

function initializeList(){
	var lsHtml = [];
	for(var i = 0; i < wordsArray.length; i++){
		lsHtml.push("<li id='ls");
		lsHtml.push(i);
		lsHtml.push("'>");
		lsHtml.push(wordsArray[i]);
		lsHtml.push("</li>");
	}
	lsHtml = lsHtml.join('');
	list.append($(lsHtml));
}

function getCells(x, y){
	return $(cells[y * dimension + x]);
}

function dropAblock(){
	if( gameOver == true ){
		return;
	}
	letter = generateLetter();
	var randNum = Math.floor(Math.random()*dimension);
	var clss = 'col0-' + randNum;
	var newButton = "<button id='btn" + blockId + "' onclick= 'callMethods(this.id)' class= 'btn btn-inverse'>" + letter + "</button>";

	var btn = document.getElementById(clss).innerHTML = newButton;
	dropAblockCont(clss, btn, randNum, 0);
}
function dropAblockCont(clss, btn, randNum, counter){
	if(gameOver==true){
		return;
	}
	var stop;
	var newCounter = counter + 1;
	var newClss = 'col' + newCounter  + '-' + randNum;

		pullingBlocks = setTimeout(function(){
			if(newCounter == dimension){
				buttons = table.find('button');
				var tower = highestTower();
				calculatePossible();
				
					suspense();
				
				blockId++;

				if(loseGame(tower)){
					win = false;
					return;
				}
					if(level == 5){
						Time = 500;
					}
					droppingBlocks = setTimeout(function() {  
                	  dropAblock() } , Time);
				
			}
			else{

				if(document.getElementById(newClss).innerHTML == ''){
					document.getElementById(clss).innerHTML = '';
					document.getElementById(newClss).innerHTML = btn;
					dropAblockCont(newClss, btn, randNum, newCounter);
				}

				else{
					buttons = table.find('buttonson');
					var tower = highestTower();
					calculatePossible();
					
						suspense();
					
					blockId++;
					if(loseGame(tower)){
						win = false;
						return;
					}
					if(level == 5){
						Time = 500;
						newTime = Time - 425;
					}
					droppingBlocks = setTimeout(function() {
						dropAblock() 
					}, Time);// <-------- set the new block arrive time, here
				}
			}
		}, newTime);// <------set the drop fall time here
}

function calculatePossible(){
	var allLetters = '';
	var l = table.find('button');
	for(var i = 0; i < l.length; i++){
		allLetters += l[i].innerHTML;
	}
		var canBeFormed;
		var yesCounter;
		var tmpAllLetters;
		for(var k = 0; k < wordsArray.length; k ++){
			yesCounter = 0;
			tmpAllLetters = allLetters;
			if(canBeFormed == true){
				var postfixNum = k - 1;
				lsId = "ls" + postfixNum;
				$('#' + lsId).addClass('text-warning');
				$('#' + lsId).css( "color", "orange" );
			}
			else{
				var postfixNum = k - 1;
				lsId = "ls" + postfixNum;
				$('#' + lsId).removeClass('text-warning');
				$('#' + lsId).css( "color", "#333333" );
			}
			for(var l = 0; l < wordsArray[k].length; l++){
				canBeFormed = false;
				for(var m = 0; m < tmpAllLetters.length; m++){
					if(wordsArray[k].charAt(l) == tmpAllLetters.charAt(m)){
						yesCounter++;
						var let = wordsArray[k].charAt(l);
						var reg = new RegExp(let);
						tmpAllLetters = tmpAllLetters.replace(reg, "");
						break;
					}
				}
			}
				if(yesCounter == wordsArray[k].length){
					canBeFormed = true;
				}
				else{
					canBeFormed = false;
				}
		}
		if(canBeFormed == true){
			var postfixNum = k - 1;
			lsId = "ls" + postfixNum;
			$('#' + lsId).addClass('text-warning');
			$('#' + lsId).css( "color", "orange" );
		}
}

function stopingPoint(){
	var clss;
	var stop = false;
	for(var i = 0; i < dimension; i++){
		clss = 'col0-' + i;
		if(document.getElementById(clss).innerHTML != ''){
			stop = true;
		}
	}
	return stop;
}

function formWord(id){
	if(buttonArray.length > 0){
		for(var i = 0; i < buttonArray.length; i++){
			if(buttonArray[i].get(0) == $('#' + id).get(0)){
				if(i != buttonArray.length - 1){
					return;
				}
			}
		}
	}
	if(buttonArray.length > 0){
		if(buttonArray[buttonArray.length - 1].get(0) == $('#' + id).get(0)){	
			$('#' + id).removeClass('btn-warning');
			$('#' + id).addClass('btn-inverse');
			buttonArray.pop();
			if(buttonArray.length > 0){
				buttonArray[buttonArray.length - 1].removeClass('btn-success');
				buttonArray[buttonArray.length - 1].addClass('btn-warning');
			  	}
			return;
		}
	}
			if(buttonArray.length == 0){	
				buttonArray.push($('#' + id));
				$('#' + id).removeClass('btn-inverse');
				$('#' + id).addClass('btn-warning');
			}
			else{
				if(document.getElementById("wordLabel").innerHTML.length > 16){
					return;
				}	
					buttonArray.push($('#' + id));
					$('#' + id).removeClass('btn-inverse');
					$('#' + id).addClass('btn-warning');
					buttonArray[buttonArray.length - 2].removeClass('btn-warning');
					buttonArray[buttonArray.length - 2].addClass('btn-success');
			} 
		
}
function generateWord(){
	var newWord = '';
	for(var i = 0; i < buttonArray.length; i++){
			newWord += buttonArray[i].html();
		}	
	 
		var oldLetters = document.getElementById("wordLabel").innerHTML;
		document.getElementById("wordLabel").innerHTML = newWord;
}
 	
function callMethods(id){
	if(gameOver == true){
		return;
	}
	formWord(id);
	generateWord();
	removeAblock();
}

function calculateUpperRow(id){
	var upperRow = '';
	for(var i = 3; i < id.length; i++){
		if(id.charAt(i) == '-'){
			break;
		}
		else{
			upperRow += id.charAt(i);
		}
	}
	var upperRowInt = parseInt(upperRow) - 1;
	return upperRowInt;
}

function calculateCol(id){
	var upperCol = '';
	for(var i = 5; i < id.length; i++){
		if(id.charAt(i - 2) == '-' || id.charAt(i - 1) == '-'){
			upperCol += id.charAt(i);
		}
		else{

		}
	}
	var upperColInt = parseInt(upperCol);
	return upperColInt;
}


function removeAblock(){
	var x;
	var word = document.getElementById("wordLabel").innerHTML;
		for(x = 0; x < wordsArray.length; x++){
			if(wordsArray[x] == word){
				for(var i = 0; i < buttonArray.length; i++){
					var toBeRemovedId = buttonArray[i].closest('td').attr('id');
					$('#' + toBeRemovedId).fadeTo('slow',0.5);
					// setTimeout(function(){document.getElementById(toBeRemovedId).innerHTML = '';}, 500);
				}
				setTimeout('fadeSomething(' + x + ')' , 300);
			}
		}
}

function fadeSomething(x){
				for(var i = 0; i < buttonArray.length; i++){
					var toBeRemovedId = buttonArray[i].closest('td').attr('id');
					document.getElementById(toBeRemovedId).innerHTML = '';
					$('#' + toBeRemovedId).fadeTo('fast',1);
				}
				var lsId = "ls" + x;
				var originalLi = document.getElementById(lsId).innerHTML;
				document.getElementById(lsId).innerHTML = "<strike style='color: red;'>" + originalLi + "</strike>";
				calculateScore();
				successfulWords.push(wordsArray[x]);
				wordExistsInArray[x] = false;
				calculatePossible();
				win = true;
				for(var finished = 0; finished < wordExistsInArray.length; finished++){
					if(wordExistsInArray[finished] == true){
						win = false;
					}
				}
				if(win == true){
					buttonArray = [];
					generateWord();
					removeAblockCont();
					gameOver = true;
					// $(".zone").slideUp(1000);
					// setTimeout(function(){
					// 	getPrizes(10,10)
					// 	$(".zone").slideDown(1000);
					// }, 1000);	
					// alert("Congrats You have Finished The Level, off to the next");
					$('.zone').empty();
					$('.zone').append('<div id ="gameover-popup"' +
					'style="font-size: 1000%; color: white; position: absolute; margin-top: 120px;">' + 
					'Score: ' + score + '</div>');
					$('#gameover-popup').fadeTo(0,0);
					$('#gameover-popup').fadeTo(1500,1);
					$('#gameover-popup').fadeTo(1500,0);
					setTimeout(function(){
						setWordsArray();
						have_to_sign_in();
						return;
					}, 3000);
				}		
				
				buttonArray = [];
				generateWord();
				removeAblockCont();
				}
function removeAblockCont(){
	var hasUpper;
	var count;
	var testFlag;
	for(var rows = dimension - 1; rows > 0; rows--){
		for(var cols = 0; cols < dimension; cols++){
			var createdId = "col" + rows + "-" + cols;
			if(document.getElementById(createdId).innerHTML == ""){
				count = 0;
				hasUpper = false;
				for(var r = rows - 1; r > 0; r--){
					var upperRowId = "col" + r + "-" + cols;
					var upperCell = document.getElementById(upperRowId).innerHTML;
					var beingDropedId = "btn" + blockId;
					var btnBeingDropped = $(document.getElementById(beingDropedId)).closest('td').html();
					if(upperCell == ''){
						count++;
					}
					else{
						if(upperCell == btnBeingDropped){
							break;
						}
						else{
							hasUpper = true;
							break;
						}
					}
				}
				if(hasUpper == true){
					startPulling(rows, cols, count);
				}
			}
			
		}
	}
}


function startPulling(r, c, count){
	// alert('testing');
	var place = "col"+ r + "-" + c;
	var newR = r - count - 1;
	var toBePulled = "col" + newR + "-" + c;
	var btn = document.getElementById(toBePulled).innerHTML;
	document.getElementById(toBePulled).innerHTML = '';
	document.getElementById(place).innerHTML = btn;

}


function generateLetter(){
	var letter;
	var stringOfWords = '';
	for(var i = 0; i < wordsArray.length; i++){
		if(wordExistsInArray[i] == true){
			for(var j = 0; j < wordsArray[i].length; j++){
				stringOfWords =stringOfWords +  wordsArray[i].charAt(j);
			}
		}	
	}
	length = stringOfWords.length;
	var randNumber = Math.floor(Math.random() * length);
	letter = stringOfWords.charAt(randNumber);
	return letter;
}


function pause(){
	clearTimeout(suspenseTimer);
	// $("td[id*='-5']").fadeTo('slow',0.5).fadeTo('fast',1);
	// $('#main').addClass('hide');
	// alert("you have paused the game, click ok to continue");
	// $('#main').removeClass('hide');
}

function clearWord(){
	document.getElementById('wordLabel').innerHTML = '';
	for(var i = 0; i < buttonArray.length; i++){
		buttonArray[i].removeClass('btn-warning');
		buttonArray[i].removeClass('btn-success');
		buttonArray[i].addClass('btn-inverse');
	}
	buttonArray = [];
	generateWord();
}

// function removeDuplicates(){
// 	var occurence;
// 	var allBlocks = table.find('button');
// 	for(var check = 0; check < allBlocks.length; check++){
// 		occurence = 0;	
// 		for(var all = 0; all < allBlocks.length; all++){
// 			if(allBlocks[check].getAttribute('id') == allBlocks[all].getAttribute('id')){
// 				occurence ++;
// 			}
// 		}
// 		if(occurence > 1){
// 			// alert($(allBlocks[check]).closest('td').html());
// 			var btn = $(allBlocks[check]).closest('td').html();
// 			var cellId = $(allBlocks[check]).closest('td').attr('id');
// 			document.getElementById(cellId).innerHTML = '';
// 			return;
// 			// document.getElementById(cellId).innerHTML = btn;
// 		}
// 	}
// }
function nextLevel(){
	level++;
	$('.zone').empty();
	$('.zone').append('<div><table class="table1" id="main-table"></table></div>' +
	'<div id="list-div" class="well" style=""><ol id="wordsList"></ol>' + 
	'<div class="label-div"><label id="wordLabel" class="label1"></label></div></div>' +
	'<br><br><div class="buttons-div">' + gameButtonClear + gameButtonRestart +'</div>' +
	'<br><br>'+ 
	'<div style="float: right;width: 220px;"><h3 id="score">SCORE: ' + score + '</h3></div>'+
	'<div id ="level-popup" style="font: helvetica; font-size: 1400%; color: white; position: absolute; margin-top: 120px;"> LEVEL ' + level  +'</div>');
	$('#level-popup').fadeTo(0,0);
	$('#level-popup').fadeTo(1500,1);
	$('#level-popup').fadeTo(1500,0);
	setTimeout(function(){
		$('#level-popup').remove();
		$('#main-table').empty();
		$('#wordsList').empty();
		$('#level').empty();
		buttonArray = [];
		bigTower = '';
		gameOver = false;
		successfulWords = [];
		clearTimeout(pullingBlocks);
		clearTimeout(droppingBlocks);
		if(numberOfCalls > 0){
			// alert('here dawg');
			clearTimeout(suspenseTimer);
			numberOfCalls = 0;
		}
		startGame();
	}, 3500);
	
}

function highestTower(){
	var towerHeight;
	var heighestSoFar = 0;
	for(var cols = 0; cols < dimension; cols++){
		towerHeight = 0;
		for(var rows = dimension - 1; rows > -1; rows--){
			cellId = "col" + rows + "-" + cols;
			if(document.getElementById(cellId).innerHTML != ''){
				towerHeight++;
			}
			else{
				break;
			}
		}
		if(towerHeight > heighestSoFar){
			heighestSoFar = towerHeight;
		}
	}
	return heighestSoFar;
}

function animate(){
	var pixelsRight = parseInt((document.getElementById('list-div').style.right).replace('px',''));
	// alert(pixelsRight);
	document.getElementById('list-div').style.right = pixelsRight + 10 +'px'; // pseudo-property code: Move right by 10px
	setTimeout(function(){animate();}, 20); // call doMove() in 20 msec
}

function suspense(){
	if(bigTower == highestTowerId()){	
		return;
	}
	else{
		bigTower = highestTowerId();
		numberOfCalls = 0;
		if(highestTower() > 7){
			if(numberOfCalls == 0){
				numberOfCalls++;
				suspenseCont(bigTower);
			}
		}
	}
}

function suspenseCont(col){
		suspenseTimer = setTimeout(function(){
			var suffix = "-" + col;
			$("td[id*=" + suffix + "]").fadeTo('fast', 0.7).fadeTo('fast',1);
			suspenseCont(col);
		}, 500);
}
function highestTowerId(){
	var towerHeight;
	var towerCol;
	var heighestSoFar = 0;
	for(var cols = 0; cols < dimension; cols++){
		towerHeight = 0;
		for(var rows = dimension - 1; rows > -1; rows--){
			cellId = "col" + rows + "-" + cols;
			if(document.getElementById(cellId).innerHTML != ''){
				towerHeight++;
			}
			else{
				break;
			}
		}
		if(towerHeight > heighestSoFar){
			heighestSoFar = towerHeight;
			towerCol = cols;
		}
	}
	return towerCol;
}

function getNewWords(num){
	$.get("/games/getnewwords/?count=" + num +"&lang=" + lang);
}

function setLevelAttributes(level){
if(level == 1){
	getNewWords(2);
	for(var x = 0; x < wordsArray.length; x++){
			wordsArray[x] = wordsArray[x].toUpperCase();
	}
		for(var i = 0; i < wordsArray.length; i++){
			wordExistsInArray[i] = true;
		}
		initializeGame();
		initializeList();
		calculatePossible();
		dropAblock();
}


if(level == 6){
		alert("Thank You for Playing, you're Awesome!!");
		return;
	}
	if(level == 2){
		getNewWords(3);
		for(var x = 0; x < wordsArray.length; x++){
			wordsArray[x] = wordsArray[x].toUpperCase();
		}
		for(var i = 0; i < wordsArray.length; i++){
			wordExistsInArray[i] = true;
		}
		initializeGame();
		initializeList();
		calculatePossible();
		dropAblock();
	}
	if(level == 3){
		getNewWords(4);
		for(var x = 0; x < wordsArray.length; x++){
			wordsArray[x] = wordsArray[x].toUpperCase();
		}
		for(var i = 0; i < wordsArray.length; i++){
			wordExistsInArray[i] = true;
		}
		initializeGame();
		initializeList();
		calculatePossible();
		dropAblock();
	}
	if(level == 4){
		getNewWords(5);
		for(var x = 0; x < wordsArray.length; x++){
			wordsArray[x] = wordsArray[x].toUpperCase();
		}
		for(var i = 0; i < wordsArray.length; i++){
			wordExistsInArray[i] = true;
		}
		initializeGame();
		initializeList();
		calculatePossible();
		dropAblock();
	}
	if(level == 5){
		getNewWords(5);
		for(var x = 0; x < wordsArray.length; x++){
			wordsArray[x] = wordsArray[x].toUpperCase();
		}
		for(var i = 0; i < wordsArray.length; i++){
			wordExistsInArray[i] = true;
		}
		initializeGame();
		initializeList();
		calculatePossible();
		dropAblock();
	}
}

function setLang(l){
	$('.zone').empty();
	$(".zone").slideUp(1000);
	$(".zone").slideDown(1000);
	lang = l;
	setTimeout(function(){
		
		newGame();
	}, 1100);
}
function calculateScore(){
	score = parseInt(document.getElementById('score').innerHTML.replace('SCORE: ', ''));
	score = score + (100 * level);
	document.getElementById('score').innerHTML = "SCORE: " + score;

}

function loseGame(t){
	if(t > dimension - 1){
		gameOver = true;
		buttonArray = [];
		generateWord();
		clearTimeout(suspenseTimer);
		clearTimeout(pullingBlocks);
		clearTimeout(droppingBlocks);
		$('tr').fadeOut('slow');
		setTimeout(function(){$('tr').fadeIn('slow');
		$('tr').empty();
		}, 500);
		$('.zone').append('<div id ="gameover-popup"' +
		'style="font-size: 1000%; color: white; position: absolute; margin-top: 120px;">' + 
		'Game Over!</div>');
		$('#gameover-popup').fadeTo(0,0);
		$('#gameover-popup').fadeTo(1500,1);
		$('#gameover-popup').fadeTo(1500,0);
		setWordsArray();
		setTimeout(function(){
			have_to_sign_in();
			return true;
		}, 3000);
	}

	else{
		return false;
	}

}

function getScore(){
	return score;
}
function getLevel(){
	return level;
}
