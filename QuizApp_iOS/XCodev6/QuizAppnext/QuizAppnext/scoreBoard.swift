//
//  scoreBoard.swift
//  QuizAppnext
//
//  Created by Ankita on 8/28/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import MSF

class scoreBoard : UIViewController{
    
    var scoreval:String = ""
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
   
    
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        playAgainButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        playAgainButton.backgroundColor = UIColor.whiteColor()
        playAgainButton.layer.cornerRadius = 8
        playAgainButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.backgroundColor = UIColor.whiteColor()
        doneButton.layer.cornerRadius = 8
        doneButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        score.textColor = UIColor.orangeColor()
        scorelabel.textColor = UIColor.orangeColor()
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        scoreval = ShareController.sharedInstance.getScore() as String
        score.text = scoreval
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateQuestionPlayAgain:", name: "PlayAgainQuestionRecieved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "DonePlayingAction:", name: "DonePlaying", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showplayerTypeonSessionEndonScore:", name: "sessionEndonScore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playAgainRecievedAction:", name: "playAgainRecieved", object: nil)
     
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "PlayAgainQuestionRecieved", object: nil) //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "DonePlaying", object: nil) //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "sessionEndonScore", object: nil) //1234
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        
        var  dic:NSDictionary  = ["finish":"Done"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        ShareController.sharedInstance.disconnect()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let thankyouViewController  = storyBoard.instantiateViewControllerWithIdentifier("thankYouView") as! thankYouViewController
    //    self.navigationController?.pushViewController(thankyouViewController, animated: true)
    
    }
    
    
    @IBAction func playAgainButtonAction(sender: AnyObject) {
        
        var  dic:NSDictionary  = ["playAgain":"playAgain"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
    }

    func leftNavButtonClick(sender:UIButton!)
    {
        var  dic:NSDictionary  = ["session":"end"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
    }
    
    
    
    
     func updateQuestionPlayAgain(notification: NSNotification!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ viewControllers.count - 1], animated: true)//
    }
   
    func DonePlayingAction(notification: NSNotification!)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let thankyouViewController = storyBoard.instantiateViewControllerWithIdentifier("thankYouView") as! thankYouViewController
        self.navigationController?.pushViewController(thankyouViewController, animated: true)
        
    }
    
    func showplayerTypeonSessionEndonScore(notification: NSNotification!)
    {
        var clientName = ShareController.sharedInstance.getClientName()
        clientName = clientName + " has ended session"
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
    
    func playAgainRecievedAction(notification : NSNotification!)
    {
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
    }
    
}