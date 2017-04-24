//
//  ShareController.swift
//  chatApp
//
//  Created by CHIRAG BAHETI on 09/07/15.
//  Copyright (c) 2015 CHIRAG BAHETI. All rights reserved.
//

import Foundation
import AssetsLibrary
import SmartView


class ShareController : ServiceSearchDelegate, ChannelDelegate
{
    static let sharedInstance = ShareController()
    let search = Service.search()
    var app: Application?
    var appURL: String = "http://prod-multiscreen-examples.s3-website-us-west-1.amazonaws.com/examples/photoshare/tv/"
    //var appURL: String = "http://www.google.com"
    var channelId: String = "com.samsung.multiscreen.quizApp"
    var isConnecting: Bool = false
    var services = [Service]()
   
    var imageByte:Data?
    var userNameText : String = ""
    var playerType : String = ""
    var playerSelected: Bool = false
    var defaultImage:Data?
    var refreshOrStop:Int?
    var msgString :NSString = ""
     var score :String = ""
    var clientName:String = ""
    var connectionType:Bool = false
    
    init () {
        search.delegate = self
       
    }
    
    func searchServices() {
        search.start()
        //   updateCastStatus()
    }
    
    func connect(_ service: Service) {
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
           
        }
        
        app = service.createApplication(URL(string: appURL)! as AnyObject,channelURI: channelId, args: nil)
        app!.delegate = self
      //  app!.connectionTimeout = 5
        self.isConnecting = true
        //  self.updateCastStatus()
        app!.connect()
    }
    
    func stopSearch(_ status: Int)
    {
        refreshOrStop = status
        search.stop()
    }
    
   @objc func onClientConnect(_ client: ChannelClient)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "clientGetsConnected"), object: self, userInfo: ["addClient":client])
    }
    
    ///  :param: client: The Client that just disconnected from the Channel
    @objc func onClientDisconnect(_ client: ChannelClient)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "clientGetsDisconnected"), object: self, userInfo: ["removeClient":client])
    }
    
    @objc func onConnect(_ client: ChannelClient?, error: NSError?) {
        
        NSLog("CLIENT CONNECTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "channelGetsConnected"), object: self, userInfo: nil)
    }
    
    @objc func onDisconnect(_ client: ChannelClient?, error: NSError?) {
        print(error)
        search.start()
        app = nil
        isConnecting = false
        //   updateCastStatus()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "channelGetsDisConnected"), object: self, userInfo: nil)
    }
    
     @objc func onMessage(_ message: Message)
    {
        NSLog("Message Received")
        print("message is \(message.data) from \(message.from)")
        let item:NSString = message.data as! NSString
        msgString = item
        
        let jsonData = item.data(using: String.Encoding.utf8.rawValue)
        
        do {
        
            let json = try JSONSerialization.jsonObject(with: jsonData!, options:JSONSerialization.ReadingOptions.mutableContainers)

            
        if let jsonDict = json as? NSDictionary{
            
            if(jsonDict["question"] != nil)
            {
            
                
             /*   if(jsonDict["question"] as? String == "finish")
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("lastQuestionRecieved", object: self, userInfo: nil)
                }
                else{*/
                NotificationCenter.default.post(name: Notification.Name(rawValue: "questionRecieved"), object: self, userInfo: nil)
              //  }
            }
            else if(jsonDict["response"] != nil)
            {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "sendAnswer"), object: self, userInfo: nil)
                
            }
      
            else if(jsonDict["Score"] != nil)
            {
                
                score = (jsonDict["Score"] as? String)!
                NotificationCenter.default.post(name: Notification.Name(rawValue: "scoreRecieved"), object: self, userInfo: nil)
                
            }
            else if(jsonDict["playerType"] != nil)
            {
                if(jsonDict["playerType"]  as? String == "MultiPlayer")
                {
                clientName = (jsonDict["clientName"] as? String)!
               
                NotificationCenter.default.post(name: Notification.Name(rawValue: "MultiplayerRequest"), object: self, userInfo: nil)
               }
                
            }
            else if(jsonDict["multiPlayer"] as? String == "yes")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "MultiplayerQuestionRecieved"), object: self, userInfo: nil)
                playerSelected = true
            }
            else if(jsonDict["multiPlayer"] as? String == "no")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "MultiplayerNORecieved"), object: self, userInfo: nil)
                playerSelected = true
            }
            else if(jsonDict["disconnect"] as? String == "true")
            {
                   clientName = (jsonDict["clientName"] as? String)!
                   NotificationCenter.default.post(name: Notification.Name(rawValue: "Disconnected"), object: self, userInfo: nil)
                
            }
            else if(jsonDict["session"] as? String == "end")
            {
                clientName = (jsonDict["clientName"] as? String)!
                NotificationCenter.default.post(name: Notification.Name(rawValue: "sessionEnd"), object: self, userInfo: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "sessionEndonScore"), object: self, userInfo: nil)
            }
            else if(jsonDict["connectionState"] as? String == "buzy")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "stateBusy"), object: self, userInfo: nil)
            }
            else if(jsonDict["connectionState"] as? String == "available")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "stateAvailable"), object: self, userInfo: nil)
            }
            else if(jsonDict["finish"] as? String == "Done")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "DonePlaying"), object: self, userInfo: nil)
            }
            else if(jsonDict["changeCategory"] as? String == "yes")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "changeCategory"), object: self, userInfo: nil)
            }
            else if(jsonDict["playAgain"] as? String == "playAgain")
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "playAgainRecieved"), object: self, userInfo: nil)
            }
            
        }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
        
    }
    
    @objc func onData(_ message: Message, payload: Data)
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
    func onServiceFound(_ service: SmartView.Service)
    {
        services.append(service)
        //    updateCastStatus()
    }
    
    @objc func onServiceLost(_ service: SmartView.Service)
    {
        _ = removeObject(&services,object: service)
        //  updateCastStatus()
    }
    @objc func clearServices()
    {
        services.removeAll(keepingCapacity: true)
    }
    
    @objc func onStop() {
        
        if(connectionType == true)
        {
            searchServices()
            connectionType = false
        }
        if (refreshOrStop == 1)
        {
            services.removeAll(keepingCapacity: false)
        }
    }
    
    func removeObject<T:Equatable>(_ arr:inout Array<T>, object:T) -> T? {
        if let found = arr.index(of: object) {
            return arr.remove(at: found)
        }
        return nil
    }
    
    func launchApp(_ appId: String, index: Int)
    {
        let tempService = services[index] as Service
        
        app = tempService.createApplication(appId as AnyObject, channelURI: channelId, args:nil)
        app?.delegate = self
        self.isConnecting = true
        // connect to the Tv using username text as attribute
        app!.connect( ["name":userNameText])
    }
    
    func launchAppWithURL(_ appURL: String, index:Int, timeOut: Int)
    {
        let tempService = services[index] as Service
        
        app = tempService.createApplication(URL(string: appURL)! as AnyObject, channelURI: channelId, args: nil)
        
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
    
    func SendToHost(_ msgText: String)
    {
        if(app != nil)
        {
            NSLog("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            if(msgText.isEmpty == true)
            {
                
          
            }
            else
            {
                app!.publish(event: "say", message: msgText as AnyObject? ,target: MessageTarget.Host.rawValue as AnyObject)
            }

        }
    }
    
    func SendToHost(_ msgtext:NSString)
    {
        
        if(app != nil)
        {
            app!.publish(event: "say", message: msgtext ,target: MessageTarget.Host.rawValue as AnyObject)
        }
        
    }
    
    func SendToAll(_ msgText: String)
    {
        if(app != nil)
        {
            app?.publish(event: msgText, message: "hello" as AnyObject?)
        }
    }
    
    func SendBroadcast(_ msgText: String)
    {
        if(app != nil)
        {
            app!.publish(event: "say", message: "Hello All of you" as AnyObject?, target: MessageTarget.Broadcast.rawValue as AnyObject)
        }
    }
    
    func SendToClient(_ msgText: String, clientID :String)
    {
        if(app != nil)
        {
            
            let dic = ["Message":msgText, "ClientID":clientID]
            
            do {
                let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            
                let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )

                print("data is \(dataString)")
            
                app!.publish(event: "say", message: dataString , target: MessageTarget.Host.rawValue as AnyObject)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        
        }
    }
    
    
    func SendToManyClients(_ msgText: String)
    {
        if(app != nil)
        {
            app!.publish(event: msgText, message: "Hello Client 1" as AnyObject?, target: app!.getClients() as AnyObject)
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
    
    func getImageData(_ dataofimage : Data)
    {
        imageByte = dataofimage
        
    }
    func setUserName(_ userName : String)
    {
        userNameText = userName
        
    }
    
    func setPlayerType(_ plyertype : String)
    {
        playerType = plyertype
     
    }
    
  
    func disconnect()
    {
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
            
            services.removeAll(keepingCapacity: false)
        }
    }
    
    func disconnect(_ connectiontype :Bool)
    {
        connectionType = connectiontype
        search.stop()
        
        if (app != nil)
        {
            app?.disconnect()
            
            services.removeAll(keepingCapacity: false)
        }
    }
    
    func  getMessageData() ->NSString
    {
        
       return msgString
    }
    func  getScore( ) ->NSString
    {
        
        return score as NSString
    }
    func getPlayerType() ->NSString
    {
        return playerType as NSString
    }
    func getClientName() ->String
    {
        return clientName
    }
    
}
