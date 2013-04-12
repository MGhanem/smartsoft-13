describe("newGame", function() {
  it("asserts the table exists", function() {
  	newGame();
    expect($('<table class="table1" id="main-table"></table>')).toExist();
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
  	setTimeout(function(){ expect(document.getElementById('wordLabel').innerHTML.toBe('gsgsd'));}, 5);
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





