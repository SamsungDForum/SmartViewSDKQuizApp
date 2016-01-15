//
//  MultiplayerviewController.swift
//  QuizAppnext
//
//  Created by Ankita on 9/3/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit


class MultiplayerviewController : UIViewController
{
    
    @IBOutlet weak var playingqueslabel: UILabel!
    @IBOutlet weak var clientName: UILabel!
    
    @IBOutlet weak var nobutton: UIButton!
    
    @IBOutlet weak var yesbutton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        clientName.text = ShareController.sharedInstance.getClientName()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showCategoryPage:", name: "changeCategory", object: nil)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        
        yesbutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        yesbutton.backgroundColor = UIColor.whiteColor()
        yesbutton.layer.cornerRadius = 8
        yesbutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        nobutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nobutton.backgroundColor = UIColor.whiteColor()
        nobutton.layer.cornerRadius = 8
        nobutton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        playingqueslabel.textColor = UIColor.orangeColor()
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        self.navigationItem.leftBarButtonItem?.title = "quit"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        let  dic:NSDictionary  = ["multiPlayer":"no"]
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
    
    @IBAction func multiplayerYesbuttonAction(sender: AnyObject)
    {
        let  dic:NSDictionary  = ["multiPlayer":"yes"]
        do {
            let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
            self.navigationController?.pushViewController(questionScreenViewController, animated: true)
           }
            catch let error as NSError
            {
                print("error \(error)")
            }
    }
    
    @IBAction func multiplayerNobuttonAction(sender: AnyObject)
    {
        let  dic:NSDictionary  = ["multiPlayer":"no"]
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
    
    func showCategoryPage(notification:NSNotification)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[2], animated: true)
    }
    
    
}