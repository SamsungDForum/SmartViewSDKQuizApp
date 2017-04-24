//
//  ClientListViewController.swift
//  chatApp
//
//  Created by CHIRAG BAHETI on 27/07/15.
//  Copyright (c) 2015 CHIRAG BAHETI. All rights reserved.
//

import Foundation
import UIKit
import SmartView

class ClientListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var clientList:[ChannelClient] = []
    var selectedTVName:String?
    
    var allIds:[String] = []
    var allNames: [String] = []
    
    @IBOutlet weak var allClientListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allClientListView.delegate = self
        allClientListView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ClientListViewController.clientConnected(_:)), name: NSNotification.Name(rawValue: "clientGetsConnected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ClientListViewController.clientDisconnected(_:)), name: NSNotification.Name(rawValue: "clientGetsDisconnected"), object: nil)
       
       
        self.navigationItem.title = "Quiz App"
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(ClientListViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let buttonRefresh: UIButton = UIButton(type: UIButtonType.custom)
        buttonRefresh.frame = CGRect(x: 300, y: 5, width: 30, height: 30)
        buttonRefresh.setImage(UIImage(named:"refresh_Image.png"), for:UIControlState())
        buttonRefresh.addTarget(self, action: #selector(ClientListViewController.rightNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        allClientListView.backgroundView = UIImageView(image: UIImage(named: "back1.jpg"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "clientGetsConnected"), object: nil)  //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "clientGetsDisconnected"), object: nil)  //1234
       // NSNotificationCenter.defaultCenter().removeObserver(self, name: "MultiplayerRequest", object: nil)  //1234
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
        let  dic:NSDictionary  = ["session":"end"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
    }
    
    func rightNavButtonClick(_ sender:UIButton!)
    {
        allNames.removeAll(keepingCapacity: false)
        allIds.removeAll(keepingCapacity: false)
        
        clientList = ShareController.sharedInstance.getAllConnectedClients()
        
        for index in 0 ..< clientList.count
        {
            var tempDict : [String:String] = (clientList[index].attributes as? [String : String])!
            let nameValue = tempDict["name"]
            
            print("name value is \(nameValue) and id is \(clientList[index].id)")
            
            if(nameValue != String(UIDevice.current.name) && clientList[index].isHost != true)
            {
                allNames.append(nameValue!)
                
                allIds.append(clientList[index].id)
            }
        }
        
        print("client list %d",clientList.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        clientList = ShareController.sharedInstance.getAllConnectedClients()
        
        if(allNames.count > 0)
        {
            allNames.removeAll(keepingCapacity: false)
        }
        
        if(allIds.count > 0)
        {
            allIds.removeAll(keepingCapacity: false)
        }
        
        for index in 0 ..< clientList.count
        {
            var tempDict : [String:String] = (clientList[index].attributes as? [String : String])!
            let nameValue = tempDict["name"]
            
            print("name value is \(nameValue) and id is \(clientList[index].id)")
            
            if(nameValue != ShareController.sharedInstance.userNameText/*String(UIDevice.currentDevice().name)*/ && clientList[index].isHost != true)
            {
                allNames.append(nameValue!)
                
                allIds.append(clientList[index].id)
            }
        }
        
        print("client list %d",clientList.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        NSLog("client list count is %d", clientList.count)
        
        return allNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        cell.backgroundView = UIImageView(image: UIImage(named: "back1.jpg"))
        cell.textLabel?.text = allNames[indexPath.row]
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        cell.textLabel?.textColor = UIColor.orange
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Connect to client"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let catergoryTypeViewController = storyBoard.instantiateViewController(withIdentifier: "categoryTypeView") as! CategoryViewController
        
        let  dic:NSDictionary  = ["clientID":allIds[indexPath.row]]
        
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
        
        print("data is \(dataString)")
        
        ShareController.sharedInstance.SendToHost(dataString!)
        self.navigationController?.pushViewController(catergoryTypeViewController, animated: true)
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    func clientConnected(_ notification: Notification!) {
        
        let client = notification.userInfo?["addClient"] as! ChannelClient
        
        var tempDict : [String:String] = (client.attributes as? [String : String])!
        let nameValue = tempDict["name"]
        
        print(
            "name value is \(nameValue) and id is \(client.id)")
        
        allNames.append(nameValue!)
        
        allIds.append(client.id)
        
        allClientListView.reloadData()
    }
    
    func clientDisconnected(_ notification: Notification!) {
        
        let client = notification.userInfo?["removeClient"] as! ChannelClient
        
        var tempDict : [String:String] = (client.attributes as? [String : String])!
        let nameValue = tempDict["name"]
        
        print("name value is \(nameValue) and id is \(client.id)")
        
        for index in 0 ..< allNames.count
        {
            if (client.id == allIds[index] && nameValue == allNames[index])
            {
                allIds.remove(at: index)
                allNames.remove(at: index)
                
                allClientListView.reloadData()
            }
        }
    }
    
  /*  func playMultiplayer(notification: NSNotification!)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let multiPlayerViewController = storyBoard.instantiateViewControllerWithIdentifier("MultiPlayerView") as! MultiplayerviewController
        self.navigationController?.pushViewController(multiPlayerViewController, animated: true)
        //TEST
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
        
        
    }*/
    
}
