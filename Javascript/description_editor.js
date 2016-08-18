$(window).load(function(){
	//Limit for cards description
	var limit = 280;
	//Hide feed
	var displays = $(".card_display");
	for(i=0; i<displays.length;i++)
		$(displays[i]).attr("style","opacity: 0");
	setTimeout(function(){		
		$("#xslRss .card_layout .description").each(function(e){			
			var descText = "";
			var img = $(this).find("p");
			$(this).find("p").remove();
			if($(this).text().length >= (limit-4)){
				//remove last 4 chars and add ...
				descText = $(this).text().substr(0,limit-4);
				descText = descText + " ...";
			}
			else{
				descText = $(this).text().substr(0, limit);
			}
			$(this).text("");
			//create image div
			$(this).append("<div class=\"card_image\"></div>");
			if(img.length == 0){
				//if no image is given, the times of malta logo will be default
				$(this).find(".card_image").append("<p><img class='card_icon' src='http://mentintranet/SiteAssets/Webparts/RssFeed/timesofmalta_logo.png' alt='Card Icon' /></p>");
			}
			console.log("end");
			$(this).find(".card_image").append(img);
			//create description div
			$(this).append("<div class=\"card_description\"></div>");
			$(this).find(".card_description").append(descText);
			//give image div class "card_icon"
			$(".xslRss .card_image img").attr("class","card_icon");
		});
	},400);
	//Show feed
	for(i=0; i<displays.length;i++)
		$(displays[i]).attr("style","opacity: 1");
});
