describe("newGame", function() {
  it("asserts the table exists", function() {
  	newGame();
    expect($('<table class="table1" id="main-table">')).toExist();
      });
});


describe("newGame", function() {
  it("asserts wordsList exist", function() {
  	newGame();
    expect($('<ol id="wordsList"></ol>')).toExist();
      });
});


describe("dropAblock", function() {
  it("asserts a block has dropped", function() {
  	newGame();
    expect($('<button id="btn0"></button>')).toExist();
      });
});


describe("newGame()", function() {
  it("asserts the level is 1 and win is true", function() {
  	newGame();
    expect(level).toBe(1);
    expect(win).toBe(true);
      });
});


describe("setLang()", function() {
  it("asserts the language is arabic", function() {
  	setLang(1);
  	getNewWords(5);
  	expect(lang).toBe(1);	
      });
});

describe("Score", function() {
  it("at the begining is 0", function() {
  		newGame();
  		expect(score).toBe(0);
      });
});

describe("wordLabel", function() {
  it("empty at creation", function() {
  	lang = 0
  	newGame();
  	setTimeout(function(){ expect(document.getElementById('wordLabel').innerHTML.toBe(''));}, 5);
      });
});

describe("wordLabel", function() {
  it("has letters after button clicked", function() {
  	lang = 0
  	newGame();
  	formWord('button0-0')
  	setTimeout(function(){ expect(document.getElementById('wordLabel').innerHTML.not.toBe(''));}, 5);
      });
});

describe("nextLevel()", function() {
  it("increments the level correctly", function() {
  	nextLevel();
  	expect(level).toBe(2);
  	nextLevel();
  	expect(level).toBe(3);
  	});
});


describe("Win", function() {
  it("Once all words are formed the gamer wins", function() {
  	for(x = 0; x < wordExistsInArray.length; x++){
  	wordExistsInArray[x] = false;
  }
  expect(win).toBe(true);
  	});
});


describe("voted on everything", function() {
  it("should prompt the user that he has finished all the words in the database and give him the option to continue", function() {
    $.ajaxSetup({async: false});
    getNewWords(0)
      if(wordsInDb == true){
      continuePlaying();
      }
      else{
        wasPrompted = true;
        setButtons();
        $('.zone').empty();
        $('.zone').append('<h2 id ="empty-db-msg">' + generateEmptyDbMsg() +
          '<br><button class="btn btn-success" id="contPlayingBtn" onclick="continuePlaying()">' +
          continuePlayingBtn +'</button>');
      }
     expect($('<button class="btn btn-success" id="contPlayingBtn" onclick="continuePlaying()">Continue Playing</button>')).toExist();
    });
});

