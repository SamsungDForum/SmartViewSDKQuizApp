function msfHandler() {


    var instance = this,
    	//ms = window.webapis.multiscreen,
        deviceListCallback,
        eventCallback,
        hostChannel,
        tvDevice,
        pinCode,
        deviceList = [],
        imageList = {},
        plyr1,
        plyr2,
        multiplyrCatg = "",
        selectedCategory,
        currentQuestnNo,
        clearIntrvl,
        clrTimeout,
        userName = "HostTV",
        device_ip = "127.0.0.1",
		questnSpace = $("#questnDisplay"),
		optnA = $("#opt_1"),
		optnB = $("#opt_2"),
		optnC = $("#opt_3"),
		optnD = $("#opt_4"), 
		questnList = $('#questionList>li'),
		categoryDiv = $("#categ"),
		quizTitle = $('#quizTitle'),
		questionSpace = $('#questionSpace'),
		quizHeader = $('#quizHeader'),
		resultPage = $('#resultPage'),
		waitingPage = $('#waiting');
		winner = $('#winner'),
		questionDisplayTime = 10000,
		answerDisplayTime = 8000;
    	connectionState = false;
    	
    // Event types
    this.EVENT_CONNECT = 201;
    this.EVENT_DISCONNECT = 202;
    this.EVENT_CONNECT_NOTIFY = 203;
    this.EVENT_DISCONNECT_NOTIFY = 204;
    this.EVENT_MESSAGE = 205;
    this.EVENT_PIN_EXPIRE = 206;
    this.EVENT_PIN_OBTAINED = 207;
    this.EVENT_ERROR = 208;
    this.EVENT_DEVICE_OBTAINED = 209;
    this.EVENT_CHANNEL_OBTAINED = 210;

    //library namespace
    var _msf = undefined;

    // Device Constants
    var APP_ID = "quizApp";
    // API constants
    var CHANNEL_CONNECT,
        CHANNEL_DISCONNECT,
        CHANNEL_CLIENT_CONNECT,
        CHANNEL_CLIENT_DISCONNECT,
        CHANNEL_MESSAGE,
        CHANNEL_ERROR;


    this.getDeviceList = function () {
        return deviceList;
    };
    this.getUserName = function () {
        return userName;
    };
    this.setUserName = function (name) {
        userName = name;
    };
    this.initialize = function(){
    	// start initializing
    	console.log("In initialise of msfHandler.js ");
//    	questionSpace.hide();
//    	resultPage.hide();
//    	waitingPage.hide();
    	try {
    		console.log(".......... window.msf  " + JSON.stringify(window.msf));
    		if(window.msf) {
    			console.log(".......... window.msf  " + JSON.stringify(window.msf));
  //      		self=this;
        		_msf = window.msf;
        		CHANNEL_CONNECT = "connect";
                CHANNEL_DISCONNECT = "disconnect";
                CHANNEL_CLIENT_CONNECT = "clientConnect";
                CHANNEL_CLIENT_DISCONNECT = "clientDisconnect";
                CHANNEL_MESSAGE = "say";
                CHANNEL_ERROR = "error";

        		if(!this.isSessionStarted()) {
        	    	_msf.local(function(err, service) {
        	    		if(err) return console.log("[openChannel] Error opening channel" + err);
        	            var channel = service.channel('com.samsung.multiscreen.quizApp');
        	            console.log("Channel created :: ")
        	            console.log(channel)
        	            hostChannel = channel;
        	            instance.setUserName(service.device.name);
        	            registerHostCallbacks();
        	            instance.connectToChannel();	            
        	    	});
            	}
                
        	} else {
        		console.log("msf 2.0 is not loaded");
        	}
    	} 
    	catch(e) {
    		console.log("msf 2.0 is not loaded");
    	}
    };
    function registerHostCallbacks() {
        console.log("[registerHostCallbacks]");
        if (hostChannel) {
            hostChannel.on(CHANNEL_CONNECT, handleConnectEvent.bind(instance));
            hostChannel.on(CHANNEL_DISCONNECT, handleDisconnectEvent.bind(instance));
            hostChannel.on(CHANNEL_CLIENT_CONNECT, handleClientConnectEvent.bind(instance));
            hostChannel.on(CHANNEL_CLIENT_DISCONNECT, handleClientDisconnectEvent.bind(instance));
            hostChannel.on(CHANNEL_MESSAGE, handleMessageEvent.bind(instance));
            hostChannel.on(CHANNEL_ERROR, handleErrorEvent.bind(instance));
            document.addEventListener( 'keydown', handleKeyDown.bind(instance));
        }
    }   
    

    var unregister = function() {
    	 hostChannel.disconnect(function (){
             //success
         	console.log(userName + ": TV is Disconnected");
         },function (err) {
             handleErrorEvent("EVENT DISCONNECT >> "+JSON.stringify(err));
             console.log("[disconnectFromChannel] Error! > " + JSON.stringify(err));
         });
            document.removeEventListener( 'keydown', handleKeyDown);
            window.tizen.application.getCurrentApplication().exit();
    }
    
    function handleKeyDown(e){
    	console.log(e.keyCode);
    	switch(e.keyCode){
	        case TvKeyCode.KEY_UP:
	        	console.log("[in up key handlder]");
//	        	console.log(document.getElementById("channelLogs").scrollTop);
//	        	scrollChannelLogs(TvKeyCode.KEY_UP);
	        	break;
	        	
	        case TvKeyCode.KEY_RETURN:
	        	console.log("[in return key handlder]");
	        	unregister();
	        	break;
	        	

	        case TvKeyCode.KEY_DOWN:
	        	console.log("[in down key handlder]");
//	        	console.log(document.getElementById("channelLogs").scrollTop);
//	        	scrollChannelLogs(TvKeyCode.KEY_DOWN);
	        	break;
	        	
    	}
    }

    /**
     *
     * @returns {boolean} connection state
     */
    this.isSessionStarted = function(){
        return connectionState;
    };

    /**
     * Host connection status
     * @returns {boolean} Host status
     */
    this.isConnected = function () {
        var result = false;
        if (hostChannel) {
            result = hostChannel.isConnected;
        }
        return result;
    };
    

    //===================================================================
    //---------------------- Outer callback methods --------------------------
    this.registerCallbackReady = function(){
        if (tvDevice){
            try{
                tvDevice.ready();
                console.log('[register callback] Success');
            }catch (error){
                console.log('[register callback] Error: '+JSON.stringify(error));
            }
        }else{
            console.log('[register callback] Not obtained Device instance');
        }
    };
    /**
     * Register callback for updating device list UI
     * @param listCallback callback
     */
    this.registerListCallback = function (listCallback) {
        if (typeof listCallback === "function") {
            deviceListCallback = listCallback;
        }
    };
    /**
     * Unregister callback for updating device list UI
     */
    this.unregisterListCallback = function () {
        deviceListCallback = undefined;
    };

    /**
     * Register callback for delivering API events
     * @param callback outer callback
     */
    this.registerEventCallback = function (callback) {
        if (typeof callback === "function") {
            eventCallback = callback;
        }

    };

    /**
     * Unregister callback for delivering API events
     */
    this.unregisterEventCallback = function () {
        eventCallback = undefined;
    };

    //===================================================================
    //---------------------- API callback methods ---------------------

    function sendEvent(eventType, eventData, extraData) {
        var event = {};
        if (eventCallback) {
            event.type = eventType;
            event.data = eventData;
            event.extraData = 'none';
            if (extraData) {
                event.extraData = extraData;
            }
            //console.log('event after sendEvent --->>>> '+event.type);
            eventCallback(event);
        }
    }

    //-----------------------------------------------------------------
    //----------------- SamsungConnect event callbacks ----------------
    // SConnect multiscreen.devices callbacks
    function handleDeviceObtained(device) {
        sendEvent(msfHandle.EVENT_DEVICE_OBTAINED, device);
    }

    function handleChannelObtained(channel) {
        sendEvent(msfHandle.EVENT_CHANNEL_OBTAINED, channel);
    }
    

    
    
    //===================================================================
    //---------------------- API callback methods ---------------------
    //------------------- Host methods ----------------------------------
    /**
     *
     */
    this.destroyHost = function () {
        hostChannel = undefined;
        tvDevice = undefined;
    };

    /**
     * Connect to created Host channel
     */
    this.connectToChannel = function () {
    	if (hostChannel) {
            var attributes = {
                name: userName
            };
            if (!this.isConnected()){
                //if connection is not established, trying to connect
                console.log(userName +": trying to connect...");
                hostChannel.connect({name: userName}, function () {
	                console.log('[connectToChannel] channel connection success!');
	            }, function (err) {
                    //handleErrorEvent("EVENT CONNECT >> "+JSON.stringify(err));
	            	console.log("[establishHostConnection] Error! > " + JSON.stringify(err));
                });
            } else {
                //if connection is established
            	console.log(userName + " is already Connected");
            }
        } else {
        	console.log("Channel not created!");
        }    
    };
    
  //------------------- Channel callbacks ----------------------------
    function handleConnectEvent(client) {
        //for checking of connection status
        connectionState = true;
        console.log("[handleConnectEvent] Host Connected!");
        var clients = hostChannel.clients;
        clients.forEach(function(client){
        	if(!client.isHost){
        		addDeviceToList(client);
        	}
        });
        sendEvent(msfHandle.EVENT_CONNECT, client);
    }

    function handleDisconnectEvent(client) {
        //for checking of connection status
        connectionState = false;
        console.log("[handleDisconnectEvent] Host disconnected!");
        sendEvent(msfHandle.EVENT_DISCONNECT, client);
    }

    function handleClientConnectEvent(client) {
        console.log("[handleClientConnectEvent] Connected Client attributes: " + JSON.stringify(client.attributes));
        addDeviceToList(client);
        sendEvent(msfHandle.EVENT_CONNECT_NOTIFY, client);
    }

    function handleClientDisconnectEvent(client) {
        console.log("[handleClientDisconnectEvent] Disconnected Client: ");
        if(plyr2 && plyr2.details.id == client.id){
        	onDisconnect();
        	var msg = {};
        	msg.disconnect = "true";
        	msg.clientName = plyr2.details.attributes.name;
        	hostChannel.publish('say', JSON.stringify(msg), plyr1.details.id);
        	sessionEnd();
        	showHomePage();
        }
        if(plyr1 && plyr1.details.id == client.id){
        	onDisconnect();
        	if(plyr2){
        		var msg = {};
            	msg.disconnect = "true";
            	msg.clientName = plyr1.details.attributes.name;
	        	hostChannel.publish('say', JSON.stringify(msg), plyr2.details.id);
        	}
        	sessionEnd();
        	showHomePage();	
        }
        removeDeviceFromList(client);
        sendEvent(msfHandle.EVENT_DISCONNECT_NOTIFY, client);
    }
    
    function onDisconnect(){
	    clearInterval(clearIntrvl);
        clearTimeout(clrTimeout);
        questnSpace.text("");
        optnA.text("");
        optnB.text("");
        optnC.text("");
        optnD.text("");
        quizTitle.text("");
        $("#currentQuestn").text("");
        $("#totalQuestn").text("");
        questionSpace.attr('class', 'hideDiv');
    }

    function handleMessageEvent(message, sender, payload) {
    	console.log("[Message] :: "+message);
    	if(payload){
    		console.log("payload received");
    	}
    	
    	message = JSON.parse(message);

	    	if(message.playerType){
	    		if(!plyr1){
	    			hostChannel.publish('say', JSON.stringify({"connectionState":"available"}), sender.id);
		    		plyr1 = Object.create(null);
		    		plyr1.details = sender;
		    		plyr1.result = 0;
		    		console.log(JSON.stringify(plyr1));
	    		}
	    		else{
	    			hostChannel.publish('say', JSON.stringify({"connectionState":"buzy"}), sender.id);
	    		}
    		}
	    	
	    	

	    	else if(message.clientID){
        		console.log("cliendID :: "+message.clientID)
        		plyr2 = Object.create(null);
        		plyr2.details = getClientById(message.clientID);
        		plyr2.result = 0;
        	}
	    	

	    	else if(message.categoryType){
		    	if(plyr2 && sender.id == plyr1.details.id)
		    	{
		    		var req = {};
		    		req.playerType = "MultiPlayer";
		    		req.clientName = plyr1.details.attributes.name; 
		    		multiplyrCatg = message.categoryType;
		    		hostChannel.publish('say', JSON.stringify(req), plyr2.details.id);
		    		showWaitingPage();
		    	}
		    	else if(plyr2 && sender.id == plyr2.details.id){
		    		var req = {};
		    		req.playerType = "MultiPlayer";
		    		req.clientName = plyr2.details.attributes.name; 
		    		multiplyrCatg = message.categoryType;
		    		hostChannel.publish('say', JSON.stringify(req), plyr1.details.id);
		    		showWaitingPage();
		    	}
		    	else{
		    		startQuiz( message.categoryType.toLowerCase());
		    	}
	    	}
	    	
	    	else if(message.changeCategory){
	    		if(sender.id == plyr1.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
	    		}
	    		else if(sender.id == plyr2.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
	    		}
	    		
	    		showHomePage();
	    	}
	    	
	    	
	    	else if(message.multiPlayer){
	    		if(message.multiPlayer.toLowerCase() == "yes"){
			    		if(sender.id == plyr2.details.id){
			    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
			    			startQuiz( multiplyrCatg.toLowerCase());
			    		}
			    		else{
			    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
			    			startQuiz( multiplyrCatg.toLowerCase());
			    		}
	    		}
	    		else if(message.multiPlayer.toLowerCase() == "no"){
	    			showHomePage();
		    		if(plyr2 && sender.id == plyr2.details.id){
		    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
		    		}
		    		else if(plyr2 && sender.id == plyr1.details.id){
		    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
		    		}
		    		sessionEnd();
	    		}
	    	}
	    	
	    	
	    	else if(message.answer){
	    		if(selectedCategory[currentQuestnNo-1].answer == message.answer){
	    			if(sender.id == plyr1.details.id){
	    				plyr1.result++;
	    				console.log("plyr1 result :: "+plyr1.result)
	    			}
	    			if(plyr2 && sender.id == plyr2.details.id){
	    				plyr2.result++;
	    				console.log("plyr2 result :: "+plyr2.result)
	    			}
	    			
	    		}
	    	}
	    	
	    	
	    	else if(message.finish){
	    		if(plyr2 && sender.id == plyr2.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
	    		}
	    		else if(plyr2 && sender.id == plyr1.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
	    		}
	    		sessionEnd();
	    		showHomePage();
	    	}
	    	
	    	
	    	else if(message.playAgain){
	    		if(plyr2 && sender.id == plyr2.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
	    		}
	    		else if(plyr2 && sender.id == plyr1.details.id){
	    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
	    		}
    			sessionEnd();
    			showHomePage();
	    	}
	    	
	    	
	    	else if(message.session){
	    		onDisconnect();
	    		if(plyr2 && sender.id == plyr2.details.id){
	    			message.clientName = plyr2.details.attributes.name;
	    			hostChannel.publish('say', JSON.stringify(message), plyr1.details.id);
	    		}
	    		else if(plyr2 && sender.id == plyr1.details.id){
	    			message.clientName = plyr1.details.attributes.name;
	    			hostChannel.publish('say', JSON.stringify(message), plyr2.details.id);
	    		}
	    		sessionEnd();
	    		showHomePage();
	    	}
//	        console.log("[handleMessageEvent] Message: " + JSON.stringify(message) + " From client: " + JSON.stringify(sender.attributes.name));
    	
        sendEvent(msfHandle.EVENT_MESSAGE, message, sender);
    }
    
    function showHomePage(){
		resultPage.attr('class', 'hideDiv');
    	questionSpace.attr('class', 'hideDiv');
    	waitingPage.attr('class', 'hideDiv');
    	categoryDiv.show();
    	quizHeader.show();
    }
    
    function showWaitingPage(){
        questionSpace.attr('class', 'hideDiv');
        categoryDiv.hide();
        quizHeader.hide();
        resultPage.attr('class', 'hideDiv');
        waitingPage.attr('class', 'showDiv');
        $("#wait_text").text(plyr1.details.attributes.name + " is waiting for " + plyr2.details.attributes.name);	
    }


    function getClientById(id) {
        var allClients,
            client;
        console.log("Print Clients Object: " + id);
        if (hostChannel) {
            allClients = hostChannel.clients;
            console.log("Print Clients Object: " + allClients);
            if (allClients) {
                client = allClients.getById(id);
                console.log("Print Client Object: " + client);
            }
        }
        return client;
    }
    
    function startQuiz(category){
    	categoryDiv.hide();
    	quizHeader.hide();
    	resultPage.attr('class', 'hideDiv');
    	waitingPage.attr('class', 'hideDiv');
    	questionSpace.attr('class', 'showDiv');
    	quizTitle.text(category.toUpperCase());
    	currentQuestnNo = 0;
    	clearQuestionSelection();
        selectedCategory = questionBank[category];
    	$("#totalQuestn").text(selectedCategory.length);
        this.quizData = {};
        
        quizData.question = selectedCategory[currentQuestnNo].question;
        quizData.option1 = selectedCategory[currentQuestnNo].option1;
        quizData.option2 = selectedCategory[currentQuestnNo].option2;
        quizData.option3 = selectedCategory[currentQuestnNo].option3;
        quizData.option4 = selectedCategory[currentQuestnNo].option4;
        quizData.questionNo = (currentQuestnNo+1) + "/" + selectedCategory.length;

    	$("#currentQuestn").text(currentQuestnNo+1);
    	updateTimer();
        
        questnSpace.text(selectedCategory[currentQuestnNo].question);
        optnA.text(selectedCategory[currentQuestnNo].option1);
        optnB.text(selectedCategory[currentQuestnNo].option2);
        optnC.text(selectedCategory[currentQuestnNo].option3);
        optnD.text(selectedCategory[currentQuestnNo].option4);
        
        hostChannel.publish('say', JSON.stringify(quizData), plyr1.details.id);
        if(plyr2){
        	hostChannel.publish('say', JSON.stringify(quizData), plyr2.details.id);
        }
        
        holdInterval = setTimeout(function(){},questionDisplayTime);
        clearTimeout(holdInterval);
        clrTimeout = setTimeout(displayResult.bind(this),answerDisplayTime);
        clearIntrvl = setInterval(displayQuiz.bind(this), questionDisplayTime);
    }
    
    function clearQuestionSelection(){
    	for(var i=1;i<questnList.length;i++){
    		questnList[i].style.background = 'inherit';
    	}
    }
    
    function updateTimer(){
    	var counter = answerDisplayTime/1000;
        $('#timer').text(counter);
        counter--;
	    var interval = setInterval(function() {
	        if (counter != 0){
		        $('#timer').text(counter)
		        counter--;
	        }else {
	        	 $('#timer').text(counter);
		            clearInterval(interval);
		        }
	    }, 1000);
    }
    

    function displayQuiz(){
    	console.log("[In display Quiz method]");
        if(currentQuestnNo == selectedCategory.length){
            finishDisplay(clearIntrvl);
        }                              
        else{
            if(currentQuestnNo){
                clearTimeout(clrTimeout);
                questnList[selectedCategory[currentQuestnNo-1].answer].style.background = 'inherit';
            }
            quizData.question = selectedCategory[currentQuestnNo].question;
            quizData.option1 = selectedCategory[currentQuestnNo].option1;
            quizData.option2 = selectedCategory[currentQuestnNo].option2;
            quizData.option3 = selectedCategory[currentQuestnNo].option3;
            quizData.option4 = selectedCategory[currentQuestnNo].option4;
            quizData.questionNo = (currentQuestnNo+1) + "/" + selectedCategory.length;
            
            hostChannel.publish('say', JSON.stringify(quizData), plyr1.details.id);
            if(plyr2){
            	hostChannel.publish('say', JSON.stringify(quizData), plyr2.details.id);
            }
            
            $("#currentQuestn").text(currentQuestnNo+1);
            updateTimer();
            questnSpace.text(selectedCategory[currentQuestnNo].question);
            optnA.text(selectedCategory[currentQuestnNo].option1);
            optnB.text(selectedCategory[currentQuestnNo].option2);
            optnC.text(selectedCategory[currentQuestnNo].option3);
            optnD.text(selectedCategory[currentQuestnNo].option4);
            clrTimeout = setTimeout(displayResult.bind(this),answerDisplayTime);
        }
    }

    function displayResult(){
    	
    	hostChannel.publish('say', JSON.stringify({"response":"answer"}), plyr1.details.id);
        if(plyr2){
        	hostChannel.publish('say', JSON.stringify({"response":"answer"}), plyr2.details.id);
        }
        questnList[selectedCategory[currentQuestnNo].answer].style.background = 'green';
        currentQuestnNo++;
    }

    function finishDisplay(clrInterval){
    	console.log("[In finish display Method]");
        clearInterval(clrInterval);
        questnList[selectedCategory[currentQuestnNo-1].answer].style.background = 'inherit';
        clearTimeout(clrTimeout);
        questnSpace.text("");
        optnA.text("");
        optnB.text("");
        optnC.text("");
        optnD.text("");
        quizTitle.text("");
        $("#currentQuestn").text("");
        $("#totalQuestn").text("");
        questionSpace.attr('class', 'hideDiv');
        categoryDiv.hide();
        quizHeader.hide();
        resultPage.attr('class', 'showDiv');
        resultDisplay();
    }
    
    function resultDisplay()
    {
    	console.log("[in result display method]");
    	var fin={};
    	fin.Score = plyr1.result+'/'+selectedCategory.length;
    	hostChannel.publish('say', JSON.stringify(fin), plyr1.details.id);
        if(plyr2){
        	fin.Score = plyr2.result+'/'+selectedCategory.length;
        	hostChannel.publish('say', JSON.stringify(fin), plyr2.details.id);
	        
	        if(plyr1.result > plyr2.result){
	        	winner.text("The winner is "+(plyr1.details.attributes.name).toUpperCase() + " with score "+plyr1.result);
	        }
	        else if(plyr2.result > plyr1.result){
	        	winner.text("The winner is "+(plyr2.details.attributes.name).toUpperCase() + " with score "+plyr2.result);
	        }
	        else{
	        	winner.text("Its a tie between "+(plyr2.details.attributes.name).toUpperCase()+" & "+(plyr1.details.attributes.name).toUpperCase());
	        }
	        plyr1.result = 0;
	        plyr2.result = 0;
        }
        else{
        	winner.text((plyr1.details.attributes.name).toUpperCase() + " your score is " + plyr1.result);
        	plyr1.result = 0;
        }
    }
    
    function sessionEnd(){
        plyr1 = undefined;
        if(plyr2){
	    	plyr2 = undefined;
	    	multiplyrCatg = "";
    	}
    }
    
    function handleErrorEvent(error) {
        sendEvent(msfHandle.EVENT_ERROR, error);
    }
    

    //===================================================================
      //--------------------- Device list methods -----------------------
      function addDeviceToList(device) {
          if (device) {
              var newDevice;
              console.log('new device, id= ' + device.id+" name= "+device.attributes.name);
              newDevice= new Device.Model(device.id, device.attributes.name);
              deviceList.push(newDevice);
              console.log('Added new device! ID= ' + device.id + " name= " + device.attributes.name);
              if (deviceListCallback) {
                  deviceListCallback(deviceList);
              }
          }
      }

      function removeDeviceFromList(device) {
          if(device){
              var id = device.id, newList = [];
              console.log('remove device, id= ' + id);
              if(deviceList){
  		        deviceList.forEach(function (item) {
  		            if (item.getId() != id) {
  		                newList.push(item);
  		            }
  		        });
              }
              deviceList = newList;
              console.log('Device removed! ID= ' + id);
              if (deviceListCallback) {
                  deviceListCallback(deviceList);
              }
          }
      }
}      

msfHandle = new msfHandler();