//
//  thankYouViewController.swift
//  QuizAppnext
//
//  Created by Ankita on 9/4/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import MSF
import Security

class thankYouViewController : UIViewController{

    @IBOutlet weak var thankyoulabel: UILabel!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        thankyoulabel.textColor = UIColor.orangeColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as! [UIViewController]
        self.navigationController?.popToViewController(viewControllers[ 0], animated: true)//
    }
    
}
