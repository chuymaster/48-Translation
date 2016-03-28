//
//  TranslateVCExtension.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/28/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit

extension TranslateVC{
    
    func keyboardWillShow(notification: NSNotification){
        translateView.frame.size.height = translateView.frame.size.height - getKeyboardHeight(notification)
        postImageView.hidden = true
    }
    
    func keyboardWillHide(notification: NSNotification){
        translateView.frame.size.height = translateView.frame.size.height + getKeyboardHeight(notification)
        if image != nil{
            postImageView.hidden = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TranslateVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TranslateVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}