var dimension = 10;
var table;
var cells;
var buttonArray = new Array();
var wordsArray = [];
var pauseFlag = true;
var gameOver = false;
var level = 1;
var droppingBlocks;
var pullingBlocks;
var suspenseTimer;
var blockId = 0;
var waitTime = 1000;
var fallingTime = 200;
var wordExistsInArray = new Array();
var bigTower = '';
var lang;
var successfulWords = [];
var win = true;
var score = 0;
var gameButtonClear;
var gameButtonRestart;
var gameOverPopUp;
var wordsInDb = true;
var levelPopUpTitle;
var booleanSuspense = new Array(dimension);
var suspenseTimerArray = new Array(dimension);
var wasPrompted = false;


// author:
//   Ali El Zoheiry.
// description:
//   newGame initialized the board(table) where the blocks will appear and initializes
//   the wordList that the keywords appear in, and also adds a popUp of the current level
//   and allows it to fadein and out then calls the startGame function to start. 
// params:
//   none
// success:
//   there are words in the database and the game zone is loaded successfuly.
// failure:
//   there are no words in the database and the gamer is prompted that he has no words.

function newGame(){
	$.ajaxSetup({async: false});
	getNewWords(1);
	if(wordsInDb == true){
	continuePlaying();
}
	else{
		wasPrompted = true;
		$('.zone').empty();
		$('.zone').append('<h2 id ="empty-db-msg">' +
			'Congratulations you have voted on every word in our database, we are very thankful for your contribution, ' +
			'You can continue playing the game without voting, although you will be seeing the same words you have voted on before</h2>' +
			'<button class="btn btn-success" onclick="continuePlaying()">' +
			'Continue Playing</button>');
	}
}
// author:
//   Ali El Zoheiry.
// description:
//   parses a few Html elements into jquery objects to be used again later in jquery syntax
//   and then calls the setLevelAttributes function. 
// params:
//   none
// success:
//   setLevelAttrivutes is called successfuly and control is handed.
// failure:
//   none.
function startGame(){
	levelTitle = $('#level');
	table = $('#main-table');
	list = $('#wordsList');
	cells = table.find('td');
	buttons = table.find('button');
	setLevelAttributes(level);
	
}
// author:
//   Ali El Zoheiry.
// description:
//   initializes the table rows and columns with fixed width, with each td having a button inside
//   having a letter inside the button which is generated from the generateLetter function. 
// params:
//   none
// success:
//   table is created successfuly with buttons and letters inside the button.
// failure:
//   none(because no words in the database is handled in the newGame function).

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
}

// author:
//   Ali El Zoheiry.
// description:
//   puts the words in the wordsArray retrieved from the database in the list of words created above 
// params:
//   none
// success:
//   the words are added successfuly in the lists.
// failure:
//   none.
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

// author:
//   Ali El Zoheiry.
// description:
//   generates a letter and creates a new button and places it in the top row in a random column
//   and then calls the dropAblockCont method. 
// params:
//   none
// success:
//   the block and the letter are generated successfuly and placed in the correct place.
// failure:
//   the game is over.

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

// author:
//   Ali El Zoheiry.
// description:
//   takes the block that was randomly placed and starts pulling it one row down each "fallingTime" milli seconds
//   which is decreased every level, until there is another block below it
//   then a new block is placed and is to be pulled. 
// params:
//   clss: it is the id of the id of the cell that contains the button to be pulled.
//   btn: it is the Html of the actual button to be pulled down.
//   randNum: is the random column number that the block was placed
//   counter: is a counter that keeps track of the number of blocks dropped
// success:
//   the block is pulled down until it reaches another button bewlow it and dropAblock is called again to read a new block.
// failure:
//   the game is over no blocks will fall.
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
					return;
				}
					droppingBlocks = setTimeout(function() {  
                	  dropAblock() } , waitTime);
				
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
						return;
					}
					
					droppingBlocks = setTimeout(function() {
						dropAblock() 
					}, waitTime);// <-------- set the new block arrive time, here
				}
			}
		}, fallingTime);// <------set the drop fall time here
}

// author:
//   Ali El Zoheiry.
// description:
//   places all the buttons currently in a table and matches their letters with the words available in the list
//   if a word could be formed from the current letters then it is given the color orange, else if it was
//   successfuly formed it is striked out and given the color red, else if it cannot be formed it will have the color grey. 
// params:
//   none
// success:
//   after each block lands this method is called and the possibilites are checked and the css is added.
// failure:
//   none.

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

// function stopingPoint(){
// 	var clss;
// 	var stop = false;
// 	for(var i = 0; i < dimension; i++){
// 		clss = 'col0-' + i;
// 		if(document.getElementById(clss).innerHTML != ''){
// 			stop = true;
// 		}
// 	}
// 	return stop;
// }

// author:
//   Ali El Zoheiry.
// description:
//   when a button is clicked it is added to an array of buttons and given a different color than the rest
//   and when a button is clicked twice, if it was the last button to be clicked it will be removed. 
// params:
//   id: is the id of the button being clicked
// success:
//   the letters are clicked and are added in an array of buttons.
// failure:
//   the gamer clicked the same button twice and that button was not at the end of the array, then nothing will happen
//   or the game is over.

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

// author:
//   Ali El Zoheiry.
// description:
//   loops over the array of buttons which was formed in the previous function and adds the current letters in
//   a label for the gamer to see. 
// params:
//   none
// success:
//   the array has buttons and they are added to the label successfuly.
// failure:
//   the array is empty or the game is over.
function generateWord(){
	var newWord = '';
	for(var i = 0; i < buttonArray.length; i++){
			newWord += buttonArray[i].html();
		}	
	 
		var oldLetters = document.getElementById("wordLabel").innerHTML;
		document.getElementById("wordLabel").innerHTML = newWord;
}

// author:
//   Ali El Zoheiry.
// description:
//   is a function to be called onClick which will add call these three functions (formWord, generateWord, removeAblock). 
// params:
//   id of the button being clicked
// success:
//   the button is clicked and the methods are called successfuly.
// failure:
//   the game is over, on click nothing will happen.

function callMethods(id){
	if(gameOver == true){
		return;
	}
	formWord(id);
	generateWord();
	removeAblock();
}

// author:
//   Ali El Zoheiry.
// description:
//   is given an id of a cell and returns the row number of the cell obove it. 
// params:
//   id of the cell which it's upperRow is required
// success:
//   the id is valid and has an upper row, it will be returned.
// failure:
//   the id is not valid or has no upper row, then nothing will happen.

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

// author:
//   Ali El Zoheiry.
// description:
//   is given an id of a cell and returns its number column number. 
// params:
//   id of the cell which it's column number is required
// success:
//   the id is valid and has a coloumn number, it will be returned.
// failure:
//   the id is not valid.

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


// author:
//   Ali El Zoheiry.
// description:
//   is called upon every button click and checks if the words in the label, are equal to
//   one of the words in the array, if so another function will be called. 
// params:
//   none
// success:
//   the words in the label match one of the words in the list.
// failure:
//   there are no words in the list or the label is empty, or the game is over.

function removeAblock(){
	var x;
	var word = document.getElementById("wordLabel").innerHTML;
		for(x = 0; x < wordsArray.length; x++){
			if(wordsArray[x] == word && wordExistsInArray[x] == true){
				for(var i = 0; i < buttonArray.length; i++){
					var toBeRemovedId = buttonArray[i].closest('td').attr('id');
					$('#' + toBeRemovedId).fadeTo('slow',0.5);
					// setTimeout(function(){document.getElementById(toBeRemovedId).innerHTML = '';}, 500);
				}
				setTimeout('fadeSomething(' + x + ')' , 300);
			}
		}
}

// author:
//   Ali El Zoheiry.
// description:
//   is called after removeAblock and is passed the index of the word in the word that was a match
//   and start looping over the buttons array and removes the buttons that successfuly formed the word
//   and also strikes out the word in the words list and changes its color to red
//   and the word that was formed is pushed in an array of successfuly formed words and a value of false
//   is added to an array of falgs to specify which word was formed to prevent it from being formed again
//   then checks if the words list is empty meaning the gamer has won, then the gamer is redirected to a different view. 
// params:
//   x: the index of the word in the wordsArray which was a match to the word being formed
// success:
//   the game is not over yet, and the buttons are successfuly removed from the board.
// failure:
//   the game is over, the gamer will lose.

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
					removeAblockCont();
					gameOver = true;
					$(".zone").slideUp(1000);
					setTimeout(function(){
						$(".zone").slideDown(1000);
					}, 1000);	
					setTimeout(function(){
						setWordsArray();
						enableNav();
						have_to_sign_in();
						return;
					}, 1000);
				}		
				else{
					buttonArray = [];
					generateWord();
					removeAblockCont();
				}
}

// author:
//   Ali El Zoheiry.
// description:
//   loops over the whole table and finds the gap (1 upper button and 1 lower button with spaces between them)
//   and calculates the size of the gap and calls the startPulling function to pull the blocks down the gap. 
// params:
//   none.
// success:
//   gaps were found and the gap size is calculated successfuly.
// failure:
//   there were no gaps(meaning the blocks removed were all from the top row).
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
	stopSuspense();
}


// author:
//   Ali El Zoheiry.
// description:
//   takes the place of the cell where the gap occured and pulls the block above it by the size of the gap. 
// params:
//   r: the row number of the cell were the gap was encountered.
//   c: the column number of the cell were the gap occured.
//   count: the size of the gap
// success:
//   the blocks were pulled successfuly and all gaps were filled.
// failure:
//   the game ended before the blocks were pulled.

function startPulling(r, c, count){
	// alert('testing');
	var place = "col"+ r + "-" + c;
	var newR = r - count - 1;
	var toBePulled = "col" + newR + "-" + c;
	var btn = document.getElementById(toBePulled).innerHTML;
	document.getElementById(toBePulled).innerHTML = '';
	document.getElementById(place).innerHTML = btn;

}


// author:
//   Ali El Zoheiry.
// description:
//   takes all of the words in the word list and places their letters in a string, then generates a random number
//   which will be the index of the letter to be generated from the string of all words. 
// params:
//   none.
// success:
//   the word list contains words and a random letter is generated.
// failure:
//   no words in the words list.

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

// author:
//   Ali El Zoheiry.
// description:
//   is called on button click of the clear word button, which deleted all the letters from the array of buttons
//   and from the label aswell, and return their color back to the default. 
// params:
//   none.
// success:
//   there was a word in the midst of formation, it will be successfuly cleared.
// failure:
//   no buttons were clicked.

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


// author:
//   Ali El Zoheiry.
// description:
//   is called upon the completion of a level, it increments the level number, and clears all the time outs
//   and resets all the global variables. 
// params:
//   none.
// success:
//   there exists a next level, it will be started.
// failure:
//   there is no next level, then the user will be promted that he has finished all the levels.

function nextLevel(){
	getNewWords(1);
	if(wordsInDb == true){
		toNextLevel();
	}
	else{
		if(wasPrompted == false){
			wasPrompted = true;
			$('.zone').empty();
			$('.zone').append('<h2 id ="empty-db-msg">' +
				'Congratulations you have voted on every word in our database, we are very thankful for your contribution, ' +
				'You can continue playing the game without voting, although you will be seeing the same words you have voted on before</h2>' +
				'<button class="btn btn-success" onclick="toNextLevel()">' +
				'Continue Playing</button>');
		}
		else{
			toNextLevel();
		}
	}
	
}

// author:
//   Ali El Zoheiry.
// description:
//   loops over the board and calculates the number of the highest column formed so far. 
// params:
//   none.
// success:
//   the board is not empty and the height of the column is calculated successfuly.
// failure:
//   the board is empty.


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

// author:
//   Ali El Zoheiry.
// description:
//   checks if any column has reached a height of 8 or greater, then passes control onto another function to add effects. 
// params:
//   none.
// success:
//   a column has reached a height of 8 or greater it will start flashing.
// failure:
//   no column reached the height of 7 or greater or this tower is already flashing.


function suspense(){
	for(x = 0; x < dimension; x++){
		var id = 'col2-' + x;
		if(document.getElementById(id).innerHTML != '' && booleanSuspense[x] != true){
			suspenseCont(x);
			booleanSuspense[x] = true;
		
		}
	}
}

// author:
//   Ali El Zoheiry.
// description:
//   checks if a column was flashing and then its height dropped to less than 8, it clears its time out and make it stop flashing. 
// params:
//   none.
// success:
//   a tower was flashing and then dropped in height it will stop flashing.
// failure:
//   no column was flashing or no column reached the required height.

function stopSuspense(){
	for(x = 0; x < booleanSuspense.length; x++){
		if(booleanSuspense[x] == true){
			var id = 'col2-' + x;
			if(document.getElementById(id).innerHTML == ''){
				clearTimeout(suspenseTimerArray[x]);
				booleanSuspense[x] = false;
			}
		}
	}
}


// author:
//   Ali El Zoheiry.
// description:
//   takes the column number of the column that reached the required height, 
//   and start making it fade in and out every 500 mili seconds. 
// params:
//   col: the column number of the column to be flashed
// success:
//   the height of this column is greater than 7, it will start flashing.
// failure:
//   none.

function suspenseCont(col){
		suspenseTimerArray[col] = setTimeout(function(){
			var suffix = "-" + col;
			$("td[id*=" + suffix + "]").fadeTo('fast', 0.7).fadeTo('fast',1);
			suspenseCont(col);
		}, 500);
}


// function highestTowerId(){
// 	var towerHeight;
// 	var towerCol;
// 	var heighestSoFar = 0;
// 	for(var cols = 0; cols < dimension; cols++){
// 		towerHeight = 0;
// 		for(var rows = dimension - 1; rows > -1; rows--){
// 			cellId = "col" + rows + "-" + cols;
// 			if(document.getElementById(cellId).innerHTML != ''){
// 				towerHeight++;
// 			}
// 			else{
// 				break;
// 			}
// 		}
// 		if(towerHeight > heighestSoFar){
// 			heighestSoFar = towerHeight;
// 			towerCol = cols;
// 		}
// 	}
// 	return towerCol;
// }

// author:
//   Ali El Zoheiry.
// description:
//   creates an ajax request with the number of words requested from the server, and the language of choice. 
// params:
//   num: number of words requested from the database
// success:
//   there are words in the database, they will be put in the javascript variable wordsArray.
// failure:
//   no words in the database.

function getNewWords(num){
	$.get("/games/getnewwords/?count=" + num +"&lang=" + lang);
}


// author:
//   Ali El Zoheiry.
// description:
//   sets different critera for each level, including speed of droping the blocks and number of words in the level. 
// params:
//   level: the current level the gamer is at.
// success:
//   the level is between the available levels in the game, this function will be called upon new level to set the criteria.
// failure:
//   none.

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

// author:
//   Ali El Zoheiry.
// description:
//   sets the language of the words to be fetched from the database, based on which button the gamer clicked. 
// params:
//   l: is an integer value, 0 meaning the language is english, 1 meaning it is arabic, 2 meaning it is both.
// success:
//   the button is clicked and the language is set.
// failure:
//   none.

function setLang(l){
	disableNav();
	$('.zone').empty();
	$(".zone").slideUp(1000);
	$(".zone").slideDown(1000);
	lang = l;
	setTimeout(function(){
		
		newGame();
	}, 1100);
}

// author:
//   Ali El Zoheiry.
// description:
//   calculates the new score that the gamer gets based on the level and each formed word. 
// params:
//   none.
// success:
//   the gamer formed a word and his score is added.
// failure:
//   none.


function calculateScore(){
	score = score + (100 * level);
	setScoreTitle();
}




function loseGame(t){
	if(t > dimension - 1){
		gameOver = true;
		win = false;
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
		'style="font-size: 300px; color: white; position: absolute; margin-top: 120px;"><p style="text-align: center;">' + 
		'النهاية</p></div>');
		$('#gameover-popup').fadeTo(0,0);
		$('#gameover-popup').fadeTo(1500,1);
		$('#gameover-popup').fadeTo(1500,0);
		setWordsArray();
		setTimeout(function(){
			enableNav();
			have_to_sign_in();
			return true;
		}, 3000);
	}

	else{
		return false;
	}
}

function continuePlaying(){
	$('.zone').empty();
	setButtons();
	setLevelPopUpTitle();
	$('.zone').append('<div><table class="table1" id="main-table"></table></div>' +
	'<div id="list-div" class="well" style=""><ol id="wordsList"></ol>' + 
	'<div class="label-div"><label id="wordLabel" class="label1"></label></div></div>'+
	'<br><br><div><h3 onclick="nextLevel()" id="game-score"></h3></div>' + 
	'<div class="buttons-div">' + gameButtonClear + gameButtonRestart +'</div>'+
	'<div id ="level-popup" style="font-size: 180px; color: white; position: absolute; margin-top: 120px; margin-right:30px;">' + levelPopUpTitle + ' ' + level  +'</div>');
	$('#level-popup').fadeTo(0,0);
	$('#level-popup').fadeTo(1500,1);
	$('#level-popup').fadeTo(1500,0);
	setTimeout(function(){
		$('#level-popup').remove();
		setScoreTitle();
		startGame();
	}, 3500);
}

function toNextLevel(){
	disableNav();
	level++;
	fallingTime = fallingTime - 15;
	waitTime = waitTime - 70;
	$('.zone').empty();
	$('.zone').append('<div><table class="table1" id="main-table"></table></div>' +
	'<div id="list-div" class="well" ><ol id="wordsList"></ol>' + 
	'<div class="label-div"><label id="wordLabel" class="label1"></label></div></div>' +
	'<div class="buttons-div">' + gameButtonClear + gameButtonRestart +'</div>' +
	'<br><br><div><h3 onclick="nextLevel()" id="game-score"></h3></div>' +
	'<div id ="level-popup" style="font-size: 180px; color: white; position: absolute; margin-top: 120px;">' + levelPopUpTitle + ' ' + level  +'</div>');
	$('#level-popup').fadeTo(0,0);
	$('#level-popup').fadeTo(1500,1);
	$('#level-popup').fadeTo(1500,0);
	setTimeout(function(){
		$('#level-popup').remove();
		$('#main-table').empty();
		$('#wordsList').empty();
		$('#level').empty();
		setScoreTitle();
		buttonArray = [];
		bigTower = '';
		gameOver = false;
		successfulWords = [];
		clearTimeout(pullingBlocks);
		clearTimeout(droppingBlocks);
		for(var x = 0; x < booleanSuspense.length; x++){
			if(booleanSuspense[x] == true){
				clearTimeout(suspenseTimerArray[x]);
				booleanSuspense[x] = false;
			}
		}
		startGame();
	}, 3500);
}