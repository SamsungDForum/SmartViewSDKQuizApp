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
        Category1Button.setTitleColor(UIColor.white, for: UIControlState())
        Category1Button.backgroundColor = UIColor.white
        Category1Button.layer.cornerRadius = 8
        Category1Button.setTitleColor(UIColor.orange, for: UIControlState())
        
        Category2Button.setTitleColor(UIColor.white, for: UIControlState())
        Category2Button.backgroundColor = UIColor.white
        Category2Button.layer.cornerRadius = 8
        Category2Button.setTitleColor(UIColor.orange, for: UIControlState())
        
        Category3Button.setTitleColor(UIColor.white, for: UIControlState())
        Category3Button.backgroundColor = UIColor.white
        Category3Button.layer.cornerRadius = 8
        Category3Button.setTitleColor(UIColor.orange, for: UIControlState())
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(CategoryViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.stateBusyAction2(_:)), name: NSNotification.Name(rawValue: "stateBusy"), object: nil)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "stateBusyAction2"), object: nil)  //1234
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

    @IBAction func Category1ButtonAction(_ sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"Sports"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewController(withIdentifier: "questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewController(withIdentifier: "waitScreenView") as! waitScreenController
            
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    @IBAction func Category2ButtonAction(_ sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"Science"]
        do {
        let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewController(withIdentifier: "questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewController(withIdentifier: "waitScreenView") as! waitScreenController
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    @IBAction func Category3ButtonAction(_ sender: AnyObject)
    {
        let  dic:NSDictionary  = ["categoryType":"History"]
        do {
        let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
        print("data is \(dataString)")
        ShareController.sharedInstance.SendToHost(dataString!)
        
            if(ShareController.sharedInstance.getPlayerType() == "Single")
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionScreenViewController = storyBoard.instantiateViewController(withIdentifier: "questionScreenView") as! QuestionScreenViewController
                self.navigationController?.pushViewController(questionScreenViewController, animated: true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let WaitScreenViewController = storyBoard.instantiateViewController(withIdentifier: "waitScreenView") as! waitScreenController
                self.navigationController?.pushViewController(WaitScreenViewController, animated: true)
            }
        }
        catch let error as NSError
        {
            print("error \(error)")
        }
    }
    
    
    func stateBusyAction2(_ notification : Notification!)
    {
        let alertView = UIAlertController(title: "QuizApp", message: "Host Busy!! Please try again later...", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
}
