//
//  scoreBoard.swift
//  QuizAppnext
//
//  Created by Ankita on 8/28/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit


class scoreBoard : UIViewController{
    
    var scoreval:String = ""
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
   
    
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(scoreBoard.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        playAgainButton.setTitleColor(UIColor.white, for: UIControlState())
        playAgainButton.backgroundColor = UIColor.white
        playAgainButton.layer.cornerRadius = 8
        playAgainButton.setTitleColor(UIColor.orange, for: UIControlState())
        doneButton.setTitleColor(UIColor.white, for: UIControlState())
        doneButton.backgroundColor = UIColor.white
        doneButton.layer.cornerRadius = 8
        doneButton.setTitleColor(UIColor.orange, for: UIControlState())
        score.textColor = UIColor.orange
        scorelabel.textColor = UIColor.orange
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        scoreval = ShareController.sharedInstance.getScore() as String
        score.text = scoreval
        
        NotificationCenter.default.addObserver(self, selector: #selector(scoreBoard.updateQuestionPlayAgain(_:)), name: NSNotification.Name(rawValue: "PlayAgainQuestionRecieved"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scoreBoard.DonePlayingAction(_:)), name: NSNotification.Name(rawValue: "DonePlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scoreBoard.showplayerTypeonSessionEndonScore(_:)), name: NSNotification.Name(rawValue: "sessionEndonScore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scoreBoard.playAgainRecievedAction(_:)), name: NSNotification.Name(rawValue: "playAgainRecieved"), object: nil)
     
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayAgainQuestionRecieved"), object: nil) //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DonePlaying"), object: nil) //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "sessionEndonScore"), object: nil) //1234
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAction(_ sender: AnyObject) {
        
        let  dic:NSDictionary  = ["finish":"Done"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        ShareController.sharedInstance.disconnect()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let thankyouViewController  = storyBoard.instantiateViewControllerWithIdentifier("thankYouView")
//        self.navigationController?.pushViewController(thankyouViewController, animated: true)
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    @IBAction func playAgainButtonAction(_ sender: AnyObject) {
        
        let  dic:NSDictionary  = ["playAgain":"playAgain"]
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
    
     func updateQuestionPlayAgain(_ notification: Notification!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[ viewControllers.count - 1], animated: true)//
    }
   
    func DonePlayingAction(_ notification: Notification!)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let thankyouViewController = storyBoard.instantiateViewController(withIdentifier: "thankYouView") as! thankYouViewController
        self.navigationController?.pushViewController(thankyouViewController, animated: true)
        
    }
    
    func showplayerTypeonSessionEndonScore(_ notification: Notification!)
    {
        var clientName = ShareController.sharedInstance.getClientName()
        clientName = clientName + " has ended session"
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
    
    func playAgainRecievedAction(_ notification : Notification!)
    {
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
    }
    
}
