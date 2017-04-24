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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MultiplayerviewController.showCategoryPage(_:)), name: NSNotification.Name(rawValue: "changeCategory"), object: nil)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        
        yesbutton.setTitleColor(UIColor.white, for: UIControlState())
        yesbutton.backgroundColor = UIColor.white
        yesbutton.layer.cornerRadius = 8
        yesbutton.setTitleColor(UIColor.orange, for: UIControlState())
        
        nobutton.setTitleColor(UIColor.white, for: UIControlState())
        nobutton.backgroundColor = UIColor.white
        nobutton.layer.cornerRadius = 8
        nobutton.setTitleColor(UIColor.orange, for: UIControlState())
        playingqueslabel.textColor = UIColor.orange
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(MultiplayerviewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        self.navigationItem.leftBarButtonItem?.title = "quit"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        let  dic:NSDictionary  = ["multiPlayer":"no"]
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
    
    @IBAction func multiplayerYesbuttonAction(_ sender: AnyObject)
    {
        let  dic:NSDictionary  = ["multiPlayer":"yes"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
            print("data is \(dataString)")
            ShareController.sharedInstance.SendToHost(dataString!)
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let questionScreenViewController = storyBoard.instantiateViewController(withIdentifier: "questionScreenView") as! QuestionScreenViewController
            self.navigationController?.pushViewController(questionScreenViewController, animated: true)
           }
            catch let error as NSError
            {
                print("error \(error)")
            }
    }
    
    @IBAction func multiplayerNobuttonAction(_ sender: AnyObject)
    {
        let  dic:NSDictionary  = ["multiPlayer":"no"]
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
    
    func showCategoryPage(_ notification:Notification)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[2], animated: true)
    }
    
    
}
