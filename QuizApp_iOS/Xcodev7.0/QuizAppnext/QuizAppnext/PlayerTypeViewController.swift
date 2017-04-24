

//
//  PlayerTypeViewController.swift
//  QuizApp
//
//  Created by Ankita on 8/13/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit

class PlayerTypeViewController : UIViewController , UITextFieldDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var singlePlayBtn: UIButton!
   
    @IBOutlet weak var multiPlayBtn: UIButton!
     var leftbuttonpressed:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerTypeViewController.channelDisConnected(_:)), name: NSNotification.Name(rawValue: "channelGetsDisConnected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerTypeViewController.stateBusyAction(_:)), name: NSNotification.Name(rawValue: "stateBusy"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerTypeViewController.playMultiplayer(_:)), name: NSNotification.Name(rawValue: "MultiplayerRequest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerTypeViewController.stateAvailableAction(_:)), name: NSNotification.Name(rawValue: "stateAvailable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerTypeViewController.showCategoryType(_:)), name: NSNotification.Name(rawValue: "Disconnected"), object: nil)
        singlePlayBtn.setTitleColor(UIColor.white, for: UIControlState())
        singlePlayBtn.backgroundColor = UIColor.white
        singlePlayBtn.layer.cornerRadius = 8
        singlePlayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        
        multiPlayBtn.setTitleColor(UIColor.white, for: UIControlState())
        multiPlayBtn.backgroundColor = UIColor.white
        multiPlayBtn.layer.cornerRadius = 8
        multiPlayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(PlayerTypeViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
       
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
              leftbuttonpressed = true
        //disconnect from the channel
        ShareController.sharedInstance.disconnect(true)
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MultiplayerRequest"), object: nil) //1234
    }
    
    @IBAction func singlePlayerAction(_ sender: AnyObject)
    {
        ShareController.sharedInstance.setPlayerType("Single")
        let  dic:NSDictionary  = ["playerType":"Single"]
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
    
    @IBAction func multiPlayerAction(_ sender: AnyObject)
    {
        ShareController.sharedInstance.setPlayerType("Multiplayer")
        let  dic:NSDictionary  = ["playerType":"Multiplayer"]
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
    
    func playMultiplayer(_ notification: Notification!)
    {
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let multiPlayerViewController = storyBoard.instantiateViewController(withIdentifier: "MultiPlayerView") as! MultiplayerviewController
        self.navigationController?.pushViewController(multiPlayerViewController, animated: true)
    }
    
    func channelDisConnected(_ notification: Notification!)
    {
      //  ShareController.sharedInstance.searchServices()
        if(leftbuttonpressed == true)
        {
            leftbuttonpressed = false
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(viewControllers[ 1], animated: true)//
            
            let dic:NSDictionary  = ["session":"end"]
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
        else
        {
            NSLog(" inside playertype's channelDisconnected")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let thankyouviewcontroller = storyBoard.instantiateViewController(withIdentifier: "thankYouView") as! thankYouViewController
            self.navigationController?.pushViewController(thankyouviewcontroller, animated: true)
        }
    }
    
    func stateBusyAction(_ notification : Notification!)
    {
        //pop up to show that the host is busy
        let alertView = UIAlertController(title: "QuizApp", message: "Host Busy!! Please try again later...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }

    func stateAvailableAction(_ notification : Notification!)
    {
        if(ShareController.sharedInstance.getPlayerType() == "Single")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let categoryViewController = storyBoard.instantiateViewController(withIdentifier: "categoryTypeView") as! CategoryViewController
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
        else
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let clientListViewController = storyBoard.instantiateViewController(withIdentifier: "ClientListView") as! ClientListViewController
            self.navigationController?.pushViewController(clientListViewController, animated: true)
            
        }
    }
    
    func showCategoryType(_ notification: Notification!)
    {
        var clientName = ShareController.sharedInstance.getClientName()
        clientName = clientName + " has ended session"
        // pop up to show that the other client has disconnected
        let alertView = UIAlertController(title: "QuizApp", message: clientName, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
            UIAlertAction in
            NSLog("OK Pressed")
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
            
        }
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
        
    }
}
