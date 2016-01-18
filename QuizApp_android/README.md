#Search

Discovering the TV on the network is the first step. Service.search() will provide search instance which is used for TV discovery.As soon as the service is found, it is updated in the TV List.

 
	private void startDiscovery( ) {
	     if ( search == null) {
	          search = Service.search(getApplicationContext ( ) );
	          search.setOnServiceFoundListener((service) -> (
	          updateTVList(service);
	     }
	});
 

To start & stop the search, search.start() &search.stop() methods are called, respectively.


	search.start( );
	search.stop( );
 

#Connect to TV

Making a Connect call to TV widget launches QuizApp widget on the TV.

To connect to the selected TV, connect method of Application class is called. “quizApp” is set as the app ID, and the username is sent as attribute.


	private static Application application = null ;
	application = service.createApplication(Uri.parse("quizApp"), "com.samsung.multiscreen.quizApp") ;
	application.connect(attribute, new Result<Client> ( )
	{
	     @Override
	     public void onSuccess(Client client)
	     {
	          application.publish("say", whichPlayer, Message.TARGET_HOST) ;
	     }
	     @Override
	     public void onError(com.samsung.multiscreen.Error error)
	     {
	          Toast.makeText(PlayClientCatActivity.this, " Please Re-Start Application", Toast.LENGTH_LONG.show( );
	     }
	});
 

#Disconnect from TV

TV list is also updated if service is lost (TV disconnected) from the network

 
	search.setOnServiceLostListener( new Search.OnServiceLostListener ( )
	{
	     @Override
	          public void onLost(Service service)
	          {
	               // Remove this service from the display list
	               removeTV(service);
	          }
	});
 

#On Client Disconnect

As and when a client gets disconnected, onDisconnect() callback will get called.


	application.setOnDisconnectListener( new Channel.OnDisconnectListener ( )
	{
	     @Override
	     public void onDisconnect(Client client) {
	          application.disconnect( );
	     }
	});
 

#On Message Received

OnMessage() callback gets called whenever a message is received.


	application.addOnMessageListener("say", new Channel.OnMessageListener( ) {
	     @Override
	     public void onMessage(Message message)
	     {
	     }
	});
 

Message can either be a question, score, session information, or any other information.  Following code snippet shows how a question and its options are fetched from the message string.


 
	try {
	     questionStr = mainObject.getString("question");
	     option1Str = mainObject.getString("option1");
	     option2Str = mainObject.getString("option2");
	     option3Str = mainObject.getString("option3");
	     option4Str = mainObject.getString("option4");
	     questionNo = mainObject.getString("questionNo");
	     } catch (JSONException e) {
	           // e.printStackTrace( );
	          }
 

 
