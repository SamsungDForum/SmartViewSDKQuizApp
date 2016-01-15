//
//  ShareController.swift
//  chatApp
//
//  Created by CHIRAG BAHETI on 09/07/15.
//  Copyright (c) 2015 CHIRAG BAHETI. All rights reserved.
//

import Foundation
import AssetsLibrary
import MSF


class ShareController : ServiceSearchDelegate, ChannelDelegate
{
    let search = Service.search()
    var app: Application?
    var appURL: String = "http://prod-multiscreen-examples.s3-website-us-west-1.amazonaws.com/examples/photoshare/tv/"
    //var appURL: String = "http://www.google.com"
    var channelId: String = "com.samsung.multiscreen.quizApp"
    var isConnecting: Bool = false
    var services = [Service]()
   
    var imageByte:NSData?
    var userNameText : String = ""
    var playerType : String = ""
    var playerSelected: Bool = false
    var defaultImage:NSData?
    var refreshOrStop:Int?
    var msgString :NSString = ""
     var score :String = ""
    var clientName:String = ""
    var connectionType:Bool = false
    class var sharedInstance : ShareController {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ShareController? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = ShareController()
        }
        return Static.instance!
    }
    
    init () {
        search.delegate = self
       
    }
    
    func searchServices() {
        search.start()
        //   updateCastStatus()
    }
    
    func connect(service: Service) {
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
           
        }
        
        app = service.createApplication(NSURL(string: appURL)!,channelURI: channelId, args: nil)
        app!.delegate = self
      //  app!.connectionTimeout = 5
        self.isConnecting = true
        //  self.updateCastStatus()
        app!.connect()
    }
    
    func stopSearch(status: Int)
    {
        refreshOrStop = status
        search.stop()
    }
    
   @objc func onClientConnect(client: ChannelClient)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("clientGetsConnected", object: self, userInfo: ["addClient":client])
        
    }
    
    ///  :param: client: The Client that just disconnected from the Channel
    @objc func onClientDisconnect(client: ChannelClient)
    {
          NSNotificationCenter.defaultCenter().postNotificationName("clientGetsDisconnected", object: self, userInfo: ["removeClient":client])
    }
    
    @objc func onConnect(client: ChannelClient?, error: NSError?) {
        
        NSLog("CLIENT CONNECTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        NSNotificationCenter.defaultCenter().postNotificationName("channelGetsConnected", object: self, userInfo: nil)
    }
    
    @objc func onDisconnect(client: ChannelClient?, error: NSError?) {
        print(error)
        search.start()
        app = nil
        isConnecting = false
        //   updateCastStatus()
        NSNotificationCenter.defaultCenter().postNotificationName("channelGetsDisConnected", object: self, userInfo: nil)
    }
    
     @objc func onMessage(message: Message)
    {
        NSLog("Message Received")
        print("message is \(message.data) from \(message.from)")
        let item:NSString = message.data as! NSString
        msgString = item
        
        let jsonData = item.dataUsingEncoding(NSUTF8StringEncoding)
        
        do {
            let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers)
        
        if let jsonDict = json as? NSDictionary{
            
            if(jsonDict["question"] != nil)
            {
            
                
             /*   if(jsonDict["question"] as? String == "finish")
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("lastQuestionRecieved", object: self, userInfo: nil)
                }
                else{*/
                NSNotificationCenter.defaultCenter().postNotificationName("questionRecieved", object: self, userInfo: nil)
              //  }
            }
            else if(jsonDict["response"] != nil)
            {
                
                NSNotificationCenter.defaultCenter().postNotificationName("sendAnswer", object: self, userInfo: nil)
                
            }
      
            else if(jsonDict["Score"] != nil)
            {
                
                score = (jsonDict["Score"] as? String)!
                NSNotificationCenter.defaultCenter().postNotificationName("scoreRecieved", object: self, userInfo: nil)
                
            }
            else if(jsonDict["playerType"] != nil)
            {
                if(jsonDict["playerType"]  as? String == "MultiPlayer")
                {
                clientName = (jsonDict["clientName"] as? String)!
               
                NSNotificationCenter.defaultCenter().postNotificationName("MultiplayerRequest", object: self, userInfo: nil)
               }
                
            }
            else if(jsonDict["multiPlayer"] as? String == "yes")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("MultiplayerQuestionRecieved", object: self, userInfo: nil)
                playerSelected = true
            }
            else if(jsonDict["multiPlayer"] as? String == "no")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("MultiplayerNORecieved", object: self, userInfo: nil)
                playerSelected = true
            }
            else if(jsonDict["disconnect"] as? String == "true")
            {
                   clientName = (jsonDict["clientName"] as? String)!
                   NSNotificationCenter.defaultCenter().postNotificationName("Disconnected", object: self, userInfo: nil)
                
            }
            else if(jsonDict["session"] as? String == "end")
            {
                clientName = (jsonDict["clientName"] as? String)!
                NSNotificationCenter.defaultCenter().postNotificationName("sessionEnd", object: self, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("sessionEndonScore", object: self, userInfo: nil)
            }
            else if(jsonDict["connectionState"] as? String == "buzy")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("stateBusy", object: self, userInfo: nil)
            }
            else if(jsonDict["connectionState"] as? String == "available")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("stateAvailable", object: self, userInfo: nil)
            }
            else if(jsonDict["finish"] as? String == "Done")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("DonePlaying", object: self, userInfo: nil)
            }
            else if(jsonDict["changeCategory"] as? String == "yes")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("changeCategory", object: self, userInfo: nil)
            }
            else if(jsonDict["playAgain"] as? String == "playAgain")
            {
                NSNotificationCenter.defaultCenter().postNotificationName("playAgainRecieved", object: self, userInfo: nil)
            }
            
        }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
        
    }
    
    @objc func onData(message: Message, payload: NSData)
    {
        NSLog("Data Received")
        print("data is \(message.data) from \(message.from) with payload \(payload)")
    }
    
    
    @objc func onReady()
    {
        
    }


    // MARK: - ServiceDiscoveryDelegate Methods -
    
    // These two delegate method will help us know when to change the cast button status
    //    @objc func onServiceFound(service: Service)
    //    {
    //
    //    }
    @objc func onServiceFound(service: Service) {
        services.append(service)
        //    updateCastStatus()
    }
    
    @objc func onServiceLost(service: Service) {
        removeObject(&services,object: service)
        //  updateCastStatus()
    }
    @objc func clearServices()
    {
        services.removeAll(keepCapacity: true)
        
    }
    
    @objc func onStop() {
        
        if(connectionType == true)
        {
            searchServices()
            connectionType = false
        }
        if (refreshOrStop == 1)
        {
            services.removeAll(keepCapacity: false)
        }
    }
    
    func removeObject<T:Equatable>(inout arr:Array<T>, object:T) -> T? {
        if let found = arr.indexOf(object) {
            return arr.removeAtIndex(found)
        }
        return nil
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
    
    func launchAppWithURL(appURL: String, index:Int, timeOut: Int)
    {
        let tempService = services[index] as Service
        
        app = tempService.createApplication(NSURL(string: appURL)!, channelURI: channelId, args: nil)
        
        app!.delegate = self
        
 
        self.isConnecting = true
        
        app!.connect()
        
    }
    
    func TerminateApp() -> Int
    {
        var running = 0;
        
        if (app != nil)
        {
            app?.disconnect()
            running = 1
        }
        
        return running
    }
    
    func SendToHost(msgText: String)
    {
        if(app != nil)
        {
            NSLog("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            if(msgText.isEmpty == true)
            {
                
          
            }
            else
            {
                app!.publish(event: "say", message: msgText ,target: MessageTarget.Host.rawValue)
            }

                   
         
        }
    }
    
    func SendToHost(msgtext:NSString)
    {
        
        if(app != nil)
        {
            app!.publish(event: "say", message: msgtext ,target: MessageTarget.Host.rawValue)
        }
        
    }
    
    func SendToAll(msgText: String)
    {
        if(app != nil)
        {
            app?.publish(event: msgText, message: "hello")
        }
    }
    
    func SendBroadcast(msgText: String)
    {
        if(app != nil)
        {
            app!.publish(event: "say", message: "Hello All of you", target: MessageTarget.Broadcast.rawValue)
        }
    }
    
    func SendToClient(msgText: String, clientID :String)
    {
        if(app != nil)
        {
            
            let dic = ["Message":msgText, "ClientID":clientID]
            
            do {
                let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            
                let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )

                print("data is \(dataString)")
            
                app!.publish(event: "say", message: dataString , target: MessageTarget.Host.rawValue)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        
        }
    }
    
    
    func SendToManyClients(msgText: String)
    {
        if(app != nil)
        {
            app!.publish(event: msgText, message: "Hello Client 1", target: app!.getClients())
        }
    }
    
    func checkConnect() ->Int
    {
        var check = 0
        
        if(app != nil)
        {
            check = 1
        }
        else
        {
            check = 0
        }
        
        return check
    }
    
    func  getAllConnectedClients() ->[ChannelClient]
    {
        
        var test:[ChannelClient] = []
        
        if(app != nil)
        {
            NSLog("real count is %d",app!.getClients().count)
            
           test =  app!.getClients()
        }
        
         NSLog("client list count in ShareController is : %d", test.count)
        return test
    }
    
    func getImageData(dataofimage : NSData)
    {
        imageByte = dataofimage
        
    }
    func setUserName(userName : String)
    {
        userNameText = userName
        
    }
    
    func setPlayerType(plyertype : String)
    {
        playerType = plyertype
     
    }
    
  
    func disconnect()
    {
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
            
            services.removeAll(keepCapacity: false)
        }

    }
    func disconnect(connectiontype :Bool)
    {
        connectionType = connectiontype
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
            
            services.removeAll(keepCapacity: false)
        }
        
    }
    func  getMessageData() ->NSString
    {
        
       return msgString
    }
    func  getScore( ) ->NSString
    {
        
        return score
    }
    func getPlayerType() ->NSString
    {
        return playerType
    }
    func getClientName() ->String
    {
        return clientName
    }
    
}
