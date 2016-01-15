//
//  Category.swift
//  QuizAppnext
//
//  Created by Ankita on 8/24/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController : UIViewController
{

    @IBOutlet weak var Category1Button: UIButton!
    @IBOutlet weak var Category2Button: UIButton!
    @IBOutlet weak var Category3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        Category1Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Category1Button.backgroundColor = UIColor.whiteColor()
        Category1Button.layer.cornerRadius = 8
        Category1Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        Category2Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Category2Button.backgroundColor = UIColor.whiteColor()
        Category2Button.layer.cornerRadius = 8
        Category2Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        Category3Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Category3Button.backgroundColor = UIColor.whiteColor()
        Category3Button.layer.cornerRadius = 8
        Category3Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateBusyAction2:", name: "stateBusy", object: nil)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "stateBusyAction2", object: nil)  //1234
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

    @IBAction func Category1ButtonAction(sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"Sports"]
        do {
            let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("waitScreenView") as! waitScreenController
            
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    @IBAction func Category2ButtonAction(sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"Science"]
        do {
        let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("waitScreenView") as! waitScreenController
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    @IBAction func Category3ButtonAction(sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"History"]
        do {
        let data =  try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("waitScreenView") as! waitScreenController
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    
    func stateBusyAction2(notification : NSNotification!)
    {
        let alertView = UIAlertController(title: "QuizApp", message: "Host Busy!! Please try again later...", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
}