function showTickets(){
	fade($("#webpartTickets .ticket_display"),"in", null);
}
// Change between ticket cards and ticket submit.
function changeViewTickets(){
	if($("#webpartTickets .slm-layout-main").attr("data-current") == "cards"){
		fade($("#webpartTickets .ticket_display"),"out",null);
		fade($("#webpartTickets .ticket_submit"),"in","add");
	}
	else if($("#webpartTickets .slm-layout-main").attr("data-current") == "add"){
		fade($("#webpartTickets .ticket_submit"),"out",null);
		fade($("#webpartTickets .ticket_display"),"in","cards");
	}
}
// template is used for nav button to switch icon.
function fade(elem, direction, template){	
	if(direction == "in"){
		$(elem).animate({		
			opacity:1,
			duration:3000
		});
		$(elem).attr("style","display:inline");
		if(template != null){			
			$("#webpartTickets .nav_button").attr("src","http://mentintranet/SiteAssets/Webparts/Tickets/nav_button_"+template+".png");
			$("#webpartTickets .slm-layout-main").attr("data-current",template);
		}
	}	
	else if(direction == "out"){	
		$(elem).animate({		
			opacity:0,
			duration:3000
		  });	
		$(elem).attr("style","display:none");	  
	}			
}