#Developing a Tizen App

###To create a Tizen App,first install Samsung Tizen TV SDK  from link http://www.samsungdforum.com/Devtools/Sdkdownload which contains Samsung TV IDE.

Start the application and select a workspace to store your tizen application .

After this ,Create a new Tizen Web Project by selecting File->New->TIzen Web Project.

From the Templates for TV-1.0 ,select Tizen Web UI Framework  Template for  Master Detail Application /Multi Page Application/Navigation Application / Single Page Application based upon your requirement and give a name to the project.

A Project with mentioned name will get created in the IDE. It will contain the folders as shown in the image.

Now you can develop your Tizen application by making changes in the files of project and adding other files.

To Run the Tizen application, Build the package of the project .You can build the project by right clicking on the name of project in the project explorer and selecting the option of “build package”.

After the completion of build, a “projectname.wgt” file will get created .

To test run on system, you can select Run as-> TV Web Simulator (right click on project name)

To Run on TV, copy the .wgt file in USB drive in directory named userwidget.Plug in the USB drive in Tizen TV .TV will install the application .Go to Smart Hub-> My Apps and run the installed application.

##Required

Needs to include Multi Screen Framework library in the HTML of web application to use its functionalities.

 
	<script language="javascript" type="text/javascript" src="./lib/msf-2.0.14.min.js"></script>
 
Msf-2.0.14.min.js should be added in the project (like in directory named lib of project) so that it can be accessed by the application for implementation of MSF functionalities.

##Service Availability

Application should check whether MSF service is available to access or not through window object.


	if ( window.msf) {
	     // your code here
	}
 

If msf is supported, then get MSF service object  by getting reference of it using local method.

Local method provides reference to msf service currently running on the Host device.


	window.msf.local( function ( ) { 
	}
 

##Channel Creation

When MSF service is available, create the channel for communication between TV and mobile devices.



	var channel = service.channel("com.samsung.multiscreen.quizApp"); // Example
 

Mobile devices will interact with the Host device(Samsung Smart TV) via the channel created.



> Register Callback : 

When Channel gets created, register the callbacks to handle the Events.

Here hostChannel is the reference of the channel created in the application.

 
	if(hostChannel) {
	     hostChannel.on(CHANNEL_CONNECT, handleConnectEvent.bind(instance));
	     hostChannel.on(CHANNEL_DISCONNECT, handleDisconnectEvent.bind(instance));
	     hostChannel.on(CHANNEL_CLIENT_CONNECT, handleClientConnectEvent.bind(instance));
	     hostChannel.on(CHANNEL_CLIENT_DISCONNECT, handleClientDisconnectEvent.bind(instance));
	     hostChannel.on(CHANNEL_MESSAGE, handleMessageEvent.bind(instance));
	     hostChannel.on(CHANNEL_ERROR,  handleErrorEvent.bind(instance));
	     document.addEventListener("keydown" , handleKeyDown.bind(instance));
	}
 

There are different callbacks that you can handle for handling the different kinds of event like:
 

##Channel Connect Event:

To handle Host connect Event

 
	function handleConnectEvent(client){
	     // sendEvent(msfHandle.EVENT_CONNECT, client);
	}
 

##Client Connect Event

To handle connected Client and its attributes.



	function handleClientConnectEvent(client){
	     // code
	}
 

##Message Sending Event

The communication is managed by handling the publish callback using the “say” event which is mapped to handleMessageEvent in the given application.


 
	function handleMessageEvent(message, sender, payload) {
	          // your code here
	}
 

 You can use publish method of host to send message to any client connected on the channel



	function handleMessageEvent(message, sender, payload) {
	     if(message.playerType) {
	          if(!plyr1) {
	          hostChannel.publish("say", JSON.stringify({"connectionState" : "available"}), sender.id);
	          }
	     }
	}
 

##Client Disconnect Event

 For Clients which are getting disconnected.

 
	function handleClientDisconnectEvent(client) {
	     // your code here
	}
 

##Disconnect Event

For Host disconnect


	function handleDisconnectEvent(client) {
	     // your code here
	}
 
