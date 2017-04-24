	
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
        
    var timer = Timer()
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
            
            NotificationCenter.default.addObserver(self, selector: #selector(QuestionScreenViewController.updateQuestion(_:)), name: NSNotification.Name(rawValue: "questionRecieved"), object: nil)
        //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendLastAnswer:", name: "lastQuestionRecieved", object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(QuestionScreenViewController.scoreCard(_:)), name: NSNotification.Name(rawValue: "scoreRecieved"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(QuestionScreenViewController.showplayerTypeonSessionEnd(_:)), name: NSNotification.Name(rawValue: "sessionEnd"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(QuestionScreenViewController.sendResponse(_:)), name: NSNotification.Name(rawValue: "sendAnswer"), object: nil)
            radioButtonController = SSRadioButtonsController(buttons: optionAbutton, optionBbutton, optionCbutton, optionDbutton)
            radioButtonController!.delegate = self
            radioButtonController!.shouldLetDeSelect = true
            
            let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
            buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
            buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
            buttonBack.addTarget(self, action: #selector(QuestionScreenViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
            
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
            self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "quit"
            
          //  optionAbutton.backgroundColor = UIColor.whiteColor()
            optionAbutton.setTitleColor(UIColor.orange, for: UIControlState())
            optionBbutton.setTitleColor(UIColor.orange, for: UIControlState())
            optionCbutton.setTitleColor(UIColor.orange, for: UIControlState())
            optionDbutton.setTitleColor(UIColor.orange, for: UIControlState())
            questionText.textColor = UIColor.orange
            questionNoLabel.textColor = UIColor.orange
            
            questionText.numberOfLines = 0
            questionNoLabel.numberOfLines = 0
            
            if(ShareController.sharedInstance.getPlayerType() == "Multiplayer"   )
            {
                let msgData = ShareController.sharedInstance.getMessageData()
                
                let jsonData = msgData.data(using: String.Encoding.utf8.rawValue)
                do {
                let json = try JSONSerialization.jsonObject(with: jsonData!, options:JSONSerialization.ReadingOptions.mutableContainers)
                let jsonDict = json as? NSDictionary
                if let jsonDict = jsonDict{
                    questionText.text = jsonDict["question"] as? String
                   
                    optionAbutton.setTitle(jsonDict["option1"] as? String, for: UIControlState())
                    optionBbutton.setTitle(jsonDict["option2"] as? String, for: UIControlState())
                    optionCbutton.setTitle(jsonDict["option3"] as? String, for: UIControlState())
                    optionDbutton.setTitle(jsonDict["option4"] as? String, for: UIControlState())
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

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "scoreRecieved"), object: nil) //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "questionRecieved"), object: nil) //1234
    //    NSNotificationCenter.defaultCenter().removeObserver(self, name: "lastQuestionRecieved", object: nil) //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "sessionEnd"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "sendAnswer"), object: nil) //1234 //1234
        
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        let  dic:NSDictionary  = ["session":"end"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
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
    

    func updateQuestion(_ notification: Notification!)
    {
        self.view.isUserInteractionEnabled = true
        let msgData = ShareController.sharedInstance.getMessageData()
        let jsonData = msgData.data(using: String.Encoding.utf8.rawValue)
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData!, options:JSONSerialization.ReadingOptions.mutableContainers)
            let jsonDict = json as? NSDictionary
            if let jsonDict = jsonDict
            {
            questionText.text = jsonDict["question"] as? String
                
            optionAbutton.setTitle(jsonDict["option1"] as? String, for: UIControlState())
            optionBbutton.setTitle(jsonDict["option2"] as? String, for: UIControlState())
            optionCbutton.setTitle(jsonDict["option3"] as? String, for: UIControlState())
            optionDbutton.setTitle(jsonDict["option4"] as? String, for: UIControlState())
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
    
    func scoreCard(_ notification : Notification)
    {
       // let score = ShareController.sharedInstance.getScore()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let scoreBoardViewController = storyBoard.instantiateViewController(withIdentifier: "scoreBoardView") as! scoreBoard
        self.show(scoreBoardViewController, sender: scoreBoardViewController)
        
    }
    
    func showplayerTypeonSessionEnd(_ notification: Notification!)
    {
        var clientName = ShareController.sharedInstance.getClientName()
        clientName = clientName + " has disconnected"
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
    
    
    func sendResponse(_ notification : Notification!)
    {
        self.view.isUserInteractionEnabled = false
         currentSelectedButton = radioButtonController?.selectedButton()
        if(currentSelectedButton == optionAbutton)
        {
            let  dic:NSDictionary  = ["answer":"1"]
            
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
        if(currentSelectedButton == optionBbutton)
        {
            let  dic:NSDictionary  = ["answer":"2"]
            
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
        if(currentSelectedButton == optionCbutton)
        {
            let  dic:NSDictionary  = ["answer":"3"]
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
        if(currentSelectedButton == optionDbutton)
        {
            let  dic:NSDictionary  = ["answer":"4"]
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
        radioButtonController?.deselect(optionAbutton)
        radioButtonController?.deselect(optionBbutton)
        radioButtonController?.deselect(optionCbutton)
        radioButtonController?.deselect(optionDbutton)
        
    
    
    
    }
    
    
}

