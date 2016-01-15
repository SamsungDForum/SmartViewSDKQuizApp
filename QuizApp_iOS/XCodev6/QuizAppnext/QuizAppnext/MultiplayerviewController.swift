//
//  MultiplayerviewController.swift
//  QuizAppnext
//
//  Created by Ankita on 9/3/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import MSF

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
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        self.navigationItem.leftBarButtonItem?.title = "quit"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func leftNavButtonClick(sender:UIButton!)
    {
        var  dic:NSDictionary  = ["multiPlayer":"no"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
    }
    
    
    @IBAction func multiplayerYesbuttonAction(sender: AnyObject)
    {
        var  dic:NSDictionary  = ["multiPlayer":"yes"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let questionScreenViewController = storyBoard.instantiateViewControllerWithIdentifier("questionScreenView") as! QuestionScreenViewController
        self.navigationController?.pushViewController(questionScreenViewController, animated: true)
    }
    
    @IBAction func multiplayerNobuttonAction(sender: AnyObject)
    {
        var  dic:NSDictionary  = ["multiPlayer":"no"]
        var data =  NSJSONSerialization.dataWithJSONObject(dic, options: nil, error: nil)!
        var dataString = NSString( data: data, encoding: NSUTF8StringEncoding )
        println("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
    }
    func showCategoryPage(notification:NSNotification)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
        
    }
    
    
}