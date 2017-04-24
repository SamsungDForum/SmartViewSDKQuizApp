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
import Security

class thankYouViewController : UIViewController{

    @IBOutlet weak var thankyoulabel: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quiz App"
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(thankYouViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        thankyoulabel.textColor = UIColor.orange
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers 
        self.navigationController?.popToViewController(viewControllers[ 0], animated: true)//
    }
    
}
