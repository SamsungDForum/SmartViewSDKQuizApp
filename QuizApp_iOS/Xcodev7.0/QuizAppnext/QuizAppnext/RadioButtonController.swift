
//
//  RadioButtonController.swift
//  QuizAppnext
//
//  Created by Ankita on 8/21/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit

/// RadioButtonControllerDelegate. Delegate optionally implements didSelectButton that receives selected button.
@objc protocol SSRadioButtonControllerDelegate {
    /**
    This function is called when a button is selected. If 'shouldLetDeSelect' is true, and a button is deselected, this function
    is called with a nil.
    
    */
    @objc optional func didSelectButton(_ aButton: UIButton?)
}

class SSRadioButtonsController : NSObject
{
    fileprivate var buttonsArray = [UIButton]()
    fileprivate weak var currentSelectedButton:UIButton? = nil
    weak var delegate : SSRadioButtonControllerDelegate? = nil
    /**
    Set whether a selected radio button can be deselected or not. Default value is false.
    */
    var shouldLetDeSelect = false
    /**
    Variadic parameter init that accepts UIButtons.
    
    :param: buttons Buttons that should behave as Radio Buttons
    */
    init(buttons: UIButton...) {
        super.init()
        for aButton in buttons {
            aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(_:)), for: UIControlEvents.touchUpInside)
        }
        self.buttonsArray = buttons
    }
    /**
    Add a UIButton to Controller
    
    :param: button Add the button to controller.
    */
    func addButton(_ aButton: UIButton) {
        buttonsArray.append(aButton)
        aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(_:)), for: UIControlEvents.touchUpInside)
    }
    /**
    Remove a UIButton from controller.
    
    :param: button Button to be removed from controller.
    */
    func removeButton(_ aButton: UIButton) {
        
        var iteration = 0;
        var iteratingButton: UIButton? = nil
        for iteration in 0 ..< buttonsArray.count {
            iteratingButton = buttonsArray[iteration]
            if(iteratingButton == aButton) {
                break
            } else {
                iteratingButton = nil
            }
        }
        if(iteratingButton != nil) {
            buttonsArray.remove(at: iteration)
            iteratingButton!.removeTarget(self, action: #selector(SSRadioButtonsController.pressed(_:)), for: UIControlEvents.touchUpInside)
            if currentSelectedButton == iteratingButton {
                currentSelectedButton = nil
            }
        }
    }
    /**
    Set an array of UIButons to behave as controller.
    
    :param: buttonArray Array of buttons
    */
    func setButtonsArray(_ aButtonsArray: [UIButton]) {
        for aButton in aButtonsArray {
            aButton.addTarget(self, action: #selector(SSRadioButtonsController.pressed(_:)), for: UIControlEvents.touchUpInside)
        }
        buttonsArray = aButtonsArray
    }
    
    func deselect(_ sender: UIButton)
    {
        if(sender.isSelected)
        {
        sender.isSelected = false
        currentSelectedButton = nil
        }
    }
    func pressed(_ sender: UIButton) {
        if(sender.isSelected) {
            if shouldLetDeSelect {
                sender.isSelected = false
                currentSelectedButton = nil
            }
        } else {
            for aButton in buttonsArray {
                aButton.isSelected = false
            }
            sender.isSelected = true
            currentSelectedButton = sender
        }
        delegate?.didSelectButton?(currentSelectedButton)
    }
    /**
    Get the currently selected button.
    
    :returns: Currenlty selected button.
    */
    func selectedButton() -> UIButton? {
        return currentSelectedButton
    }
}
