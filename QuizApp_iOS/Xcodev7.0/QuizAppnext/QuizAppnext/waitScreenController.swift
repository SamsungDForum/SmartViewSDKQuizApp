//
//  waitScreenController.swift
//  QuizAppnext
//
//  Created by Ankita on 9/2/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit


class waitScreenController : UIViewController
    
{
    @IBOutlet weak var waitinglabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateQuestionMultiplayer:", name: "MultiplayerQuestionRecieved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPlayerType:", name: "MultiplayerNORecieved", object: nil)
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        waitinglabel.textColor = UIColor.orangeColor()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MultiplayerQuestionRecieved", object: nil) //1234
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MultiplayerNORecieved", object: nil) //1234
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        let  dic:NSDictionary  = ["changeCategory":"yes"]
        do {
            let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers 
        self.navigationController?.popToViewController(viewControllers[ 3], animated: true)//
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    func updateQuestionMultiplayer(notification: NSNotification!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
        self.navigationController?.pushViewController(questionScreenViewController, animated: true)
        NSLog("EVENT MULTIPLAYQUESTION ")
    }
    
    func showPlayerType(notification: NSNotification!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
    }
    
    
}
