#Search

As soon as the user clicks the play button, the app searches the devices with MSF service available on the same network. The start method of search class is called.



	@IBAction func playButtonAction(sender: AnyObject) {
	        if(usernameText.text.isEmpty != true){
	            ShareController.sharedInstance.setUserName(usernameText.text)
	            //Start searching the services
	            ShareController.sharedInstance.searchServices()
	            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
	            let tvViewController = storyBoard.instantiateViewControllerWithIdentifier("AllTVNetworkView") as! TVListViewController
	            self.navigationController?.pushViewController(tvViewController, animated: true)
	        }
	    }
	 
	 
	func searchServices() {
	        search.start()
	        //   updateCastStatus()
	    }
 

#Connect to TV

To connect to the selected TV, connect  method of class Application  is called. “quizApp” is set as the app ID, and the username is sent as attribute


	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	        if (ShareController.sharedInstance.search.isSearching)
	        {
	            ShareController.sharedInstance.launchApp("quizApp", index: indexPath.row)
	            self.activityIndicatorView.startAnimating()
	        }
	    }
 

	func launchApp(appId: String, index: Int)
	    {
	        let tempService = services[index] as Service
	        app = tempService.createApplication(appId, channelURI: channelId, args:nil)
	        app?.delegate = self
	        self.isConnecting = true
	        // connect to the Tv using username text as attribute
	        app!.connect( ["name":userNameText])
	    }
 

#Disconnect

If a user wants to choose another TV to act as a host or wants to chat with a different user name, he/she can disconnect from the channel as shown below



	func leftNavButtonClick(sender:UIButton!)
	    {
	        leftbuttonpressed = true
	        //disconnect from the channel
	        ShareController.sharedInstance.disconnect(true)
	    }

 
	func disconnect(connectiontype :Bool){
	        connectionType = connectiontype
	        search.stop()
	        if (app != nil)
	        {
	            app?.disconnect()
	            services.removeAll(keepCapacity: false)
	        }
	    }
 
#Client Connect and Disconnect

While you are connected to a TV, the clients connected to it might disconnect or new clients may connect to it. In order to handle the connection and disconnection of these clients we have methods onClientConnect  and onClientDisconnect

 
	@objc func onClientConnect(client: ChannelClient){
	        NSNotificationCenter.defaultCenter().postNotificationName("clientGetsConnected", object: self, userInfo: ["addClient":client])
	    }
	    
	    //  :param: client: The Client that just disconnected from the Channel
	    @objc func onClientDisconnect(client: ChannelClient){
	          NSNotificationCenter.defaultCenter().postNotificationName("clientGetsDisconnected", object: self, userInfo: ["removeClient":client])
	    }
 

#Client Disconnected During Quiz

If in a multiplayer session, the other client disconnects during the quiz, we receive  message from the TV with key as disconnect and value as true  along with client name. In such a case an error pops up asking the user to choose another session

 
	func showCategoryType(notification: NSNotification!)
	    {
	        var clientName = ShareController.sharedInstance.getClientName()
	        clientName = clientName + " has ended session"
	        // pop up to show that the other client has disconnected
	        let alertView = UIAlertController(title: "QuizApp", message: clientName, preferredStyle: .Alert)
	        var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){
	            UIAlertAction in
	            NSLog("OK Pressed")
	            let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
	            self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
	        }
	        alertView.addAction(okAction)
	        presentViewController(alertView, animated: true, completion: nil)
	        
	    }
 