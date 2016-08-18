var cards = null;
var currentCard_ids = new Array();
var currentCard = null;

//15 second timer between card switch
function startTimer(){
	window.setInterval(function(){
		SwitchCard("next","xslRss");
		SwitchCard("next","xslAnnouncements");
	}, 15000);
}
//Sets starting cards.
function showAnnouncements(){
		setCurrentCard("xslAnnouncements", 0);
		$(currentCard).attr("style","filter:Alpha(opacity=100); left:0px");
		setCurrentCard("xslRss", 0);
		$(currentCard).attr("style","filter:Alpha(opacity=100); left:0px");	
}
//Set visible card
function setCurrentCard(parent_name, num){	
	var mNum = parseInt(num);
	cards = $('#'+parent_name+' .card_layout');
	var array = currentCard_ids;
	if(array.length > 0){
		for(i = 0;i<array.length;i++){
			var isContains = (array[i].indexOf(parent_name)> -1);
			if(isContains)
				array.splice(i, 1);							
		}
	}
	array.push(parent_name+"_"+mNum);	
	currentCard = cards[mNum];
	currentCard_ids = array;
}
//get visible card id
function getCurrentCardsIds(parent_name){
	var result = 0;
	var array = currentCard_ids;
	for(i = 0; i<array.length;i++){
		var isContains = (array[i].indexOf(parent_name)> -1);
		if(isContains){			
			result = array[i].split("_").pop();
		}
	}
	return parseInt(result);
}
//switch cards 
function SwitchCard(direction, parent_name){	
	var currentCard_id = getCurrentCardsIds(parent_name);
	setCurrentCard(parent_name, currentCard_id);
	var action = 0;
	//Since cards work from 1 to n not 0 to n
    var card_limit = cards.length -1;
	//Hides old card
	if(direction == "previous"){
		action = -1;
		 $(currentCard).animate({
          left: 471*action,
		  opacity: 0,
		  duration: 1500
      });
	}
	else if(direction == "next"){
		action = 1;
		 $(currentCard).animate({
          left: 471*action,
		  opacity: 0,
		  duration: 1500
      });
	}
	//Sets up current card
	if((currentCard_id+1)> card_limit && direction == "next"){
		setCurrentCard(parent_name, 0);
	}
	else if((currentCard_id-1) < 0 && direction == "previous"){
		setCurrentCard(parent_name, card_limit);
	}
	else{
		setCurrentCard(parent_name, currentCard_id+action);
	}
	//Set oncoming card to appropriate side
	$(currentCard).animate({
          left:-471*action,
		  opacity: 0,
		  duration: 1
		});
	
	//Move card current card out of vision	
	if(direction == "previous"){
		 $(currentCard).animate({
          left:0,
		  opacity: 1,
		  duration: 1500
		});
	}
	else if(direction == "next"){
		 $(currentCard).animate({
          left:0,
		  opacity: 1,
		  duration: 1500
      });
	}
}
