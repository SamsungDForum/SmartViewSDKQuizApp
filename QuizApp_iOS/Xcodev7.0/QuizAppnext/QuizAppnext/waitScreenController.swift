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
        NotificationCenter.default.addObserver(self, selector: #selector(waitScreenController.updateQuestionMultiplayer(_:)), name: NSNotification.Name(rawValue: "MultiplayerQuestionRecieved"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(waitScreenController.showPlayerType(_:)), name: NSNotification.Name(rawValue: "MultiplayerNORecieved"), object: nil)
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(waitScreenController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        waitinglabel.textColor = UIColor.orange
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MultiplayerQuestionRecieved"), object: nil) //1234
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MultiplayerNORecieved"), object: nil) //1234
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        let  dic:NSDictionary  = ["changeCategory":"yes"]
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        let dataString = NSString( data: data, encoding: String.Encoding.utf8.rawValue )
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
    
    func updateQuestionMultiplayer(_ notification: Notification!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let questionScreenViewController = storyBoard.instantiateViewController(withIdentifier: "questionScreenView") as! QuestionScreenViewController
        self.navigationController?.pushViewController(questionScreenViewController, animated: true)
        NSLog("EVENT MULTIPLAYQUESTION ")
    }
    
    func showPlayerType(_ notification: Notification!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers
        self.navigationController?.popToViewController(viewControllers[ 2], animated: true)//
    }
    
    
}
