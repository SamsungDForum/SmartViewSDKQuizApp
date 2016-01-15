//
//  aboutScreenViewController.swift
//  QuizAppnext
//
//  Created by Ankita on 9/10/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import MSF

class aboutScreenViewController : UIViewController, SSRadioButtonControllerDelegate {
    @IBOutlet weak var version: UILabel!
       @IBOutlet weak var titlelabel: UILabel!

    @IBOutlet weak var aboutText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
     
        titlelabel.textColor = UIColor.orangeColor()
        version.textColor = UIColor.whiteColor()
       aboutText.backgroundColor = UIColor.whiteColor()
        aboutText.textColor = UIColor.orangeColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

