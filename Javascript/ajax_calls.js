//Set Lists with listName, Maximum cards per list and their query.
var listPropertiesTickets = {list:'Title,Created,EndDate,TaskStatus,Author', listName:'Tickets', max:4,
query:("<View><Query><Where><Eq><FieldRef Name='Author' LookupId='True'/><Value Type='Lookup'>"+_spPageContextInfo.userId+"</Value></Eq></Where><OrderBy><FieldRef Name='Created' Ascending='FALSE' /></OrderBy></Query><RowLimit>10</RowLimit></View>")};
var listPropertiesAnnouncements = {list:'Title,Body,Importance,Created', listName:'Announcements', max:5,
query:("<View><Query><Where><Geq><FieldRef Name='ID'/><Value Type='Number'>1</Value></Geq></Where><OrderBy><FieldRef Name='Created' Ascending='FALSE' /></OrderBy></Query><RowLimit>10</RowLimit></View>")};	

$(window).load(function(){
	setTimeout(function(){	         		
		checkUser();
	},400);	
});

// After user ajax loads, retrieve lists, show ticket and announcements webparts ( opacity -> 1 ),
// and start timer for card switch after 15 seconds.
function ajaxOnLoad(){
	retrieveAll(); 
	showAnnouncements();
	showTickets();
	startTimer();
}

// Checks if user is part of group TicketManagement (ID = 51)
// IMP. Method will stop working if the group TicketManagement is deleted,
// if it is deleted, replace new id with groupId.
function checkUser() {
    var userId = _spPageContextInfo.userId;
    var groupId = 51;
    var requestHeaders = { "accept" : "application/json; odata=verbose" };

    $.ajax({
        url : _spPageContextInfo.webAbsoluteUrl + "/_api/web/sitegroups(" + groupId + ")/users/getbyid(" + userId + ")",
        contentType : "application/json;odata=verbose",
        headers : requestHeaders,
        success : onGroupSuccess,
        error :onQueryFailed("GroupSearch")
    }).done(function(){
		ajaxOnLoad();
	});
}

//If user is part of TicketManagement, query is changed to view all tickets.
function onGroupSuccess() {
	listPropertiesTickets.query = ("<View><Query><Where><Geq><FieldRef Name='ID'/>" +
		"<Value Type='Number'>1</Value></Geq></Where><OrderBy><FieldRef Name='Created' Ascending='FALSE'/></OrderBy></Query><RowLimit>10</RowLimit></View>");		
}

//Retrieve all lists needed.
function retrieveAll(){
	retrieveList(listPropertiesAnnouncements);
	retrieveList(listPropertiesTickets);
}

//Add ticket to the tickets list.
function addTicket(){		
	var clientContext = new SP.ClientContext();
	var web = clientContext.get_web();
    
    var oList = web.get_lists().getByTitle('Tickets');
	var listProperties = listPropertiesTickets;
	var input_title = $(".ticket_submit .input_title").val();
	var input_category = $(".ticket_submit .input_category option:selected").text();
	var input_body = $(".ticket_submit .input_body").val();
	var input_created = new Date();
	
	var itemCreateInfo = new SP.ListItemCreationInformation();
	
	this.oListItem = oList.addItem(itemCreateInfo);
	oListItem.set_item('Title', ""+input_title);
	oListItem.set_item('Body', ""+input_body);
	oListItem.set_item('Category', ""+input_category);
	oListItem.set_item('Created', input_created);
	oListItem.set_item('TaskStatus',"Pending");
	
	oListItem.update();
	
	var camlQuery = new SP.CamlQuery();
	camlQuery.set_viewXml(listProperties.query);
	listProperties.colListItem = oList.getItems(camlQuery);
	clientContext.load(listProperties.colListItem, "Include("+listProperties.list+")");
	
	clientContext.executeQueryAsync(function(){ onQuerySucceededTickets(listProperties)}, onQueryFailed(listProperties));
}

function retrieveList(listProperties){
	var clientContext = new SP.ClientContext();
    var oList = clientContext.get_web().get_lists().getByTitle(listProperties.listName);
	var camlQuery = new SP.CamlQuery();
	camlQuery.set_viewXml(listProperties.query);			
	listProperties.colListItem = oList.getItems(camlQuery);

	clientContext.load(listProperties.colListItem, 'Include('+listProperties.list+')');	
	//Different methods onSucceed depending on the list.
	if(listProperties.listName == 'Announcements')
		clientContext.executeQueryAsync(function(){ onQuerySucceededAnnouncements(listProperties)}, onQueryFailed(listProperties.listName));        	
	else if(listProperties.listName == 'Tickets')	
		clientContext.executeQueryAsync(function(){ onQuerySucceededTickets(listProperties)}, onQueryFailed(listProperties.listName));        	
}

function onQuerySucceededAnnouncements(listProperties) {
    var listItemInfo = '';	
    var listItemEnumerator = listProperties.colListItem.getEnumerator();
	
	//Link html elements with variables
	var card_display = $("#xslAnnouncements .card_display");
	var card_layout_innerHtml = $("#xslAnnouncements .card_layout").html();		
	var card_html = (("<div class='link-item card_layout' style='left: 471px; opacity: 0;'>")+ card_layout_innerHtml +("</div>"));
	
	//Loop of cards made
	var loop = 0;
	while (listItemEnumerator.moveNext() && loop != listProperties.max){
		if(loop > 0)
			card_display.append(card_html);
		//Get last card and edit
		var card = $("#xslAnnouncements .card_layout").last(); 
		var oListItem = listItemEnumerator.get_current();
		var date = (oListItem.get_item('Created')+"").split(" ");
		var day = date[2];
		var month = date[1];
		var year = date[3];
		//Switch Html
		$(card).find(".card_title .title").html("<b>"+oListItem.get_item('Title')+"</b>");
		$(card).find(".card_title .date").html("<b>"+day+" "+month+" "+year+"</b>");
		$(card).find(".description .card_description").html(""+oListItem.get_item('Body'));	
		$(card).find(".description .card_image img").attr("src","http://mentintranet/SiteAssets/Webparts/Announcements/announcement_icon_"+oListItem.get_item('Importance')+".png");
		loop++;
	} 
}

function onQuerySucceededTickets(listProperties) {
    var listItemInfo = '';	
    var listItemEnumerator = listProperties.colListItem.getEnumerator();		
	var card_display = $("#webpartTickets .ticket_display");
	var card_layout_innerHtml = $("#webpartTickets .card_layout").html();	
    //Html with parent element	
	var card_html = (("<div class='link-item card_layout'>")+ card_layout_innerHtml +("</div>"));
	var loop = 0;
	while (listItemEnumerator.moveNext() && loop != listProperties.max){
		if(loop > 0)
			card_display.append(card_html);
		
		var card = $("#webpartTickets .card_layout").last(); 
		var oListItem = listItemEnumerator.get_current();		
		$(card).find(".card_title").html(""+oListItem.get_item('Title'));
		var date = (oListItem.get_item('Created')+"").split(" ");		
		var day = date[2];
		var month = date[1];
		var year = date[3];
		//Switch Html
		$(card).find(".time_wrapper").html(""+day+" "+month+" "+year+"");
		$(card).find(".card_status").html("<button class='status_button "+oListItem.get_item('TaskStatus')+"' type='button' disabled>"+oListItem.get_item('TaskStatus')+"</button> ");	
		loop++;
	} 
}
// Failed method for all ajax calls
function onQueryFailed(queryName) {
    console.log('Failed: '+queryName);
}
