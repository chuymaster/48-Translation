//
//  TranslateVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Individual post with translate field view controller class
class TranslateVC: PostBaseVC, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var image: UIImage!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var bodyStack: UIStackView!
    @IBOutlet var translateView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = post.publishedAtDateString
        
        // Load image
        if image != nil{
            postImageView.image = image
            postImageView.addGestureRecognizer(longPressRecognizer)
            postImageView.addGestureRecognizer(tabRecognizer)
        }else{
            postImageView.hidden = true
        }
        
        // Set the translate box
        translatedTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        if !post.translatedContent.isEmpty{
            translatedTextView.text = post.translatedContent
            translatedTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        }else{
            // Placeholder http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
            translatedTextView.text = Message.General.MS001
            translatedTextView.textColor = UIColor.lightGrayColor()
        }
        
        // Add tap recognizer to the original text box
        let tapContent = UITapGestureRecognizer(target: self, action: #selector(TranslateVC.tapContentTextView(_:)))
        tapContent.delegate = self
        contentTextView.addGestureRecognizer(tapContent)

        // Subscribe to delegate and events
        translatedTextView.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe keyboard event
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareItem(sender: AnyObject) {
        let items = [translatedTextView.text, postImageView.image!, NSURL(string: post.url)!]
        Utilities.shareItems(self, items: items)
    }
    
}

