//
//  PostBaseVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/28/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Base view controller class for Post and Translate view controller
class PostBaseVC: UIViewController {
    
    var post: Post!
    var posts: [Post]!
    var tabRecognizer: UITapGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set gesture recognize for imageView http://stackoverflow.com/questions/32647557/save-uiimage-with-long-press
        postImageView.userInteractionEnabled = true
        tabRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostBaseVC.tabbed(_:)))
        tabRecognizer.numberOfTapsRequired = 1
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PostBaseVC.longPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        
        // Set texts
        self.title = post.title
        contentTextView.text = post.content
        // Padding
        contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        // Scroll textview to the top
        contentTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    /// Action when imageview is pressed long
    func longPressed(sender: UILongPressGestureRecognizer) {
        // Prevent consecutive calling by very long press
        if (sender.state != .Began) {
            return
        }
        // Present UIActivityViewController to share post
        Utilities.shareItems(self, items: [postImageView.image!])
    }
    
    /// Action when imageview is tabbed
    func tabbed(sender: UITapGestureRecognizer){
        if (sender.state != .Ended){
            return
        }
        // Present Photo View Controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoView") as! PhotoVC
        vc.image = postImageView.image
        vc.title = post.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
