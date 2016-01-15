//
//  FirstViewController.swift
//  QuizApp
//
//  Created by Ankita on 8/13/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit


class FirstViewController : UIViewController , UITextFieldDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        playButton.backgroundColor = UIColor.whiteColor()
        playButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        playButton.layer.cornerRadius = 8
        
        let blackcolor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        usernameText.layer.borderColor = blackcolor.CGColor
        usernameText.layer.borderWidth = 2
        usernameText.layer.cornerRadius = 8

        aboutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        aboutButton.backgroundColor = UIColor.whiteColor()
        aboutButton.layer.cornerRadius = 8
        aboutButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        UsernameLabel.textColor = UIColor.whiteColor()
        
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict
        
        self.usernameText.delegate = self
        self.navigationItem.title = "Quiz App"
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    @IBAction func playButtonAction(sender: AnyObject) {
        
        if(usernameText.text!.isEmpty != true)
        {
            ShareController.sharedInstance.setUserName(usernameText.text!)
            
            //Start searching the services
            ShareController.sharedInstance.searchServices()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tvViewController = storyBoard.instantiateViewControllerWithIdentifier("AllTVNetworkView") as! TVListViewController
            self.navigationController?.pushViewController(tvViewController, animated: true)
        }
        else
        {
            let alertView = UIAlertController(title: "QuizApp", message: "Please enter your name to login!!", preferredStyle: .Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameText.becomeFirstResponder()
        usernameText.resignFirstResponder()
        
        return true
    }
    
    
   /* override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
*/

    
}