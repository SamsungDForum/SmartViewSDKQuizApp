//
//  ClientListViewController.swift
//  chatApp
//
//  Created by CHIRAG BAHETI on 27/07/15.
//  Copyright (c) 2015 CHIRAG BAHETI. All rights reserved.
//

import Foundation
import UIKit

import MSF


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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clientConnected:", name: "clientGetsConnected", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clientDisconnected:", name: "clientGetsDisconnected", object: nil)
       
       
        self.navigationItem.title = "Quiz App"
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonRefresh.frame = CGRectMake(300, 5, 30, 30)
        buttonRefresh.setImage(UIImage(named:"refresh_Image.png"), forState:UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "rightNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        allClientListView.backgroundView = UIImageView(image: UIImage(named: "back1.jpg"))
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "clientGetsConnected", object: nil)  //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "clientGetsDisconnected", object: nil)  //1234
       // NSNotificationCenter.defaultCenter().removeObserver(self, name: "MultiplayerRequest", object: nil)  //1234
    }
    
    
    
    
    func leftNavButtonClick(sender:UIButton!)
    {
        self.navigationController?.popViewControllerAnimated(true)
        var  dic:NSDictionary  = ["session":"end"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
    }
    
    func rightNavButtonClick(sender:UIButton!)
    {
        allNames.removeAll(keepCapacity: false)
        allIds.removeAll(keepCapacity: false)
        
        clientList = ShareController.sharedInstance.getAllConnectedClients()
        
        for var index=0;index < clientList.count;++index
        {
            var tempDict : [String:String] = (clientList[index].attributes as? [String : String])!
            var nameValue = tempDict["name"]
            
            println("name value is \(nameValue) and id is \(clientList[index].id)")
            
            if(nameValue != String(UIDevice.currentDevice().name) && clientList[index].isHost != true)
            {
                allNames.append(nameValue!)
                
                allIds.append(clientList[index].id)
            }
        }
        
        println("client list %d",clientList.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        clientList = ShareController.sharedInstance.getAllConnectedClients()
        
        if(allNames.count > 0)
        {
            allNames.removeAll(keepCapacity: false)
        }
        
        if(allIds.count > 0)
        {
            allIds.removeAll(keepCapacity: false)
        }
        
        for var index=0;index < clientList.count;++index
        {
            var tempDict : [String:String] = (clientList[index].attributes as? [String : String])!
            var nameValue = tempDict["name"]
            
            println("name value is \(nameValue) and id is \(clientList[index].id)")
            
            if(nameValue != ShareController.sharedInstance.userNameText/*String(UIDevice.currentDevice().name)*/ && clientList[index].isHost != true)
            {
                allNames.append(nameValue!)
                
                allIds.append(clientList[index].id)
            }
        }
        
        println("client list %d",clientList.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        NSLog("client list count is %d", clientList.count)
        
        return allNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientCell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundView = UIImageView(image: UIImage(named: "back1.jpg"))
        cell.textLabel?.text = allNames[indexPath.row]
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        cell.textLabel?.textColor = UIColor.orangeColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Connect to client"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let catergoryTypeViewController = storyBoard.instantiateViewControllerWithIdentifier("categoryTypeView") as! CategoryViewController
        
        var  dic:NSDictionary  = ["clientID":allIds[indexPath.row]]
        
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        
        println("data is \(dataString)")
        
        ShareController.sharedInstance.SendToHost(dataString!)
        self.navigationController?.pushViewController(catergoryTypeViewController, animated: true)
    }
    
    func clientConnected(notification: NSNotification!) {
        
        let client = notification.userInfo?["addClient"] as! ChannelClient
        
        var tempDict : [String:String] = (client.attributes as? [String : String])!
        var nameValue = tempDict["name"]
        
        println(
            "name value is \(nameValue) and id is \(client.id)")
        
        allNames.append(nameValue!)
        
        allIds.append(client.id)
        
        allClientListView.reloadData()
    }
    
    func clientDisconnected(notification: NSNotification!) {
        
        let client = notification.userInfo?["removeClient"] as! ChannelClient
        
        var tempDict : [String:String] = (client.attributes as? [String : String])!
        var nameValue = tempDict["name"]
        
        println("name value is \(nameValue) and id is \(client.id)")
        
        for var index = 0; index < allNames.count; index++
        {
            if (client.id == allIds[index] && nameValue == allNames[index])
            {
                allIds.removeAtIndex(index)
                allNames.removeAtIndex(index)
                
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