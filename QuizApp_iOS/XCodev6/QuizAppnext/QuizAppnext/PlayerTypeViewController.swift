

//
//  PlayerTypeViewController.swift
//  QuizApp
//
//  Created by Ankita on 8/13/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import MSF

class PlayerTypeViewController : UIViewController , UITextFieldDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var singlePlayBtn: UIButton!
   
    @IBOutlet weak var multiPlayBtn: UIButton!
     var leftbuttonpressed:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelDisConnected:", name: "channelGetsDisConnected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateBusyAction:", name: "stateBusy", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playMultiplayer:", name: "MultiplayerRequest", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateAvailableAction:", name: "stateAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showCategoryType:", name: "Disconnected", object: nil)
        singlePlayBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        singlePlayBtn.backgroundColor = UIColor.whiteColor()
        singlePlayBtn.layer.cornerRadius = 8
        singlePlayBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        multiPlayBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        multiPlayBtn.backgroundColor = UIColor.whiteColor()
        multiPlayBtn.layer.cornerRadius = 8
        multiPlayBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
       
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
              leftbuttonpressed = true
        //disconnect from the channel
        ShareController.sharedInstance.disconnect(true)
        
    }
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MultiplayerRequest", object: nil) //1234
    }
    
    @IBAction func singlePlayerAction(sender: AnyObject)
    {
        ShareController.sharedInstance.setPlayerType("Single")
        var  dic:NSDictionary  = ["playerType":"Single"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
    }
    
    
    @IBAction func multiPlayerAction(sender: AnyObject)
    {
        ShareController.sharedInstance.setPlayerType("Multiplayer")
        var  dic:NSDictionary  = ["playerType":"Multiplayer"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
    }
    
    
   
    func playMultiplayer(notification: NSNotification!)
    {
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let multiPlayerViewController = storyBoard.instantiateViewControllerWithIdentifier("MultiPlayerView") as! MultiplayerviewController
        self.navigationController?.pushViewController(multiPlayerViewController, animated: true)
    }
    
    func channelDisConnected(notification: NSNotification!)
    {
      //  ShareController.sharedInstance.searchServices()
        if(leftbuttonpressed == true)
        {
            leftbuttonpressed = false
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
            self.navigationController?.popToViewController(viewControllers[ 1], animated: true)//
            
            
            var  dic:NSDictionary  = ["session":"end"]
            var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
            var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
            println("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
            
        }
        else
        {
            NSLog(" inside playertype's channelDisconnected")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let thankyouviewcontroller = storyBoard.instantiateViewControllerWithIdentifier("thankYouView") as! thankYouViewController
            self.navigationController?.pushViewController(thankyouviewcontroller, animated: true)
        }
    }
    
    func stateBusyAction(notification : NSNotification!)
    {
        //pop up to show that the host is busy
        let alertView = UIAlertController(title: "QuizApp", message: "Host Busy!! Please try again later...", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    func stateAvailableAction(notification : NSNotification!)
    {
        if(ShareController.sharedInstance.getPlayerType() == "Single")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let categoryViewController = storyBoard.instantiateViewControllerWithIdentifier("categoryTypeView") as! CategoryViewController
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
        else
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let clientListViewController = storyBoard.instantiateViewControllerWithIdentifier("ClientListView") as! ClientListViewController
            self.navigationController?.pushViewController(clientListViewController, animated: true)
            
        }
    }
    
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
}