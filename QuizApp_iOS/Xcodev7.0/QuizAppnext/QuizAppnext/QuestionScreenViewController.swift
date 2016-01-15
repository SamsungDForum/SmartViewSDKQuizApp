	
//
//  QuestionScreen.swift
//  QuizAppnext
//
//  Created by Ankita on 8/20/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation

import UIKit


class QuestionScreenViewController : UIViewController, SSRadioButtonControllerDelegate {
        
    var timer = NSTimer()
    var counter = 0
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var optionAbutton: UIButton!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var optionBbutton: UIButton!
    @IBOutlet weak var optionCbutton: UIButton!
    @IBOutlet weak var optionDbutton: UIButton!
    @IBOutlet weak var questionNoLabel: UILabel!
    var firstquest : Bool = true
    var currentSelectedButton:UIButton? = nil
    var radioButtonController: SSRadioButtonsController?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "Quiz App"
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateQuestion:", name: "questionRecieved", object: nil)
        //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendLastAnswer:", name: "lastQuestionRecieved", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "scoreCard:", name: "scoreRecieved", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showplayerTypeonSessionEnd:", name: "sessionEnd", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendResponse:", name: "sendAnswer", object: nil)
            radioButtonController = SSRadioButtonsController(buttons: optionAbutton, optionBbutton, optionCbutton, optionDbutton)
            radioButtonController!.delegate = self
            radioButtonController!.shouldLetDeSelect = true
            
            let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
            buttonBack.frame = CGRectMake(5, 5, 30, 30)
            buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
            buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
            self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "quit"
            
          //  optionAbutton.backgroundColor = UIColor.whiteColor()
            optionAbutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            optionBbutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            optionCbutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            optionDbutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            questionText.textColor = UIColor.orangeColor()
            questionNoLabel.textColor = UIColor.orangeColor()
            
            questionText.numberOfLines = 0
            questionNoLabel.numberOfLines = 0
            
            if(ShareController.sharedInstance.getPlayerType() == "Multiplayer"   )
            {
                let msgData = ShareController.sharedInstance.getMessageData()
                
                let jsonData = msgData.dataUsingEncoding(NSUTF8StringEncoding)
                do {
                let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers)
                let jsonDict = json as? NSDictionary
                if let jsonDict = jsonDict{
                    questionText.text = jsonDict["question"] as? String
                   
                    optionAbutton.setTitle(jsonDict["option1"] as? String, forState: UIControlState.Normal)
                    optionBbutton.setTitle(jsonDict["option2"] as? String, forState: UIControlState.Normal)
                    optionCbutton.setTitle(jsonDict["option3"] as? String, forState: UIControlState.Normal)
                    optionDbutton.setTitle(jsonDict["option4"] as? String, forState: UIControlState.Normal)
                /*    var questionNO:String = ""
                      questionNO  = (jsonDict["questionNo"] as? String)!
                   questionNO = "Question No. " + questionNO
                    questionNoLabel.text = questionNO */
                    
                    }
                }
                catch let error as NSError
                {
                    print("error \(error)")
                }
                
            }
            
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "scoreRecieved", object: nil) //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "questionRecieved", object: nil) //1234
    //    NSNotificationCenter.defaultCenter().removeObserver(self, name: "lastQuestionRecieved", object: nil) //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "sessionEnd", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "sendAnswer", object: nil) //1234 //1234
        
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        let  dic:NSDictionary  = ["session":"end"]
        do {
            let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
        
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    

    func updateQuestion(notification: NSNotification!)
    {
        self.view.userInteractionEnabled = true
        let msgData = ShareController.sharedInstance.getMessageData()
        let jsonData = msgData.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers)
            let jsonDict = json as? NSDictionary
            if let jsonDict = jsonDict
            {
            questionText.text = jsonDict["question"] as? String
                
            optionAbutton.setTitle(jsonDict["option1"] as? String, forState: UIControlState.Normal)
            optionBbutton.setTitle(jsonDict["option2"] as? String, forState: UIControlState.Normal)
            optionCbutton.setTitle(jsonDict["option3"] as? String, forState: UIControlState.Normal)
            optionDbutton.setTitle(jsonDict["option4"] as? String, forState: UIControlState.Normal)
            var questionNO = jsonDict["questionNo"] as? String
            questionNO = "Question No. " + questionNO!
            questionNoLabel.text = questionNO
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    func scoreCard(notification : NSNotification)
    {
       // let score = ShareController.sharedInstance.getScore()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let scoreBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("scoreBoardView") as! scoreBoard
        self.showViewController(scoreBoardViewController, sender: scoreBoardViewController)
        
    }
    
    func showplayerTypeonSessionEnd(notification: NSNotification!)
    {
        var clientName = ShareController.sharedInstance.getClientName()
        clientName = clientName + " has disconnected"
        let alertView = UIAlertController(title: "QuizApp", message: clientName, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){
            UIAlertAction in
            NSLog("OK Pressed")
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        }
        
        alertView.addAction(okAction)
        presentViewController(alertView, animated: true, completion: nil)
       
    }
    
    
    func sendResponse(notification : NSNotification!)
    {
        self.view.userInteractionEnabled = false
         currentSelectedButton = radioButtonController?.selectedButton()
        if(currentSelectedButton == optionAbutton)
        {
            let  dic:NSDictionary  = ["answer":"1"]
            
            do {
                let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }
        if(currentSelectedButton == optionBbutton)
        {
            let  dic:NSDictionary  = ["answer":"2"]
            
            do {
                let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
                let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
                print("data is \(dataString)")
                ShareController.sharedInstance.SendToHost(dataString!)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }
        if(currentSelectedButton == optionCbutton)
        {
            let  dic:NSDictionary  = ["answer":"3"]
            do {
            let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
                let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
                print("data is \(dataString)")
                ShareController.sharedInstance.SendToHost(dataString!)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }
        if(currentSelectedButton == optionDbutton)
        {
            let  dic:NSDictionary  = ["answer":"4"]
            do {
                let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
                let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
                print("data is \(dataString)")
                ShareController.sharedInstance.SendToHost(dataString!)
            }
            catch let error as NSError
            {
                print("error \(error)")
            }
        }
        radioButtonController?.deselect(optionAbutton)
        radioButtonController?.deselect(optionBbutton)
        radioButtonController?.deselect(optionCbutton)
        radioButtonController?.deselect(optionDbutton)
        
    
    
    
    }
    
    
}

