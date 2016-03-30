//
//  PostVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Individual post view controller class
class PostVC: PostBaseVC, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upButton: UIBarButtonItem!
    @IBOutlet weak var downButton: UIBarButtonItem!
    var photoIndex = 0
    var maxPhotoIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load image
        if !post.photos.isEmpty{
            postImageView.hidden = false
            maxPhotoIndex = post.photos.count - 1
            
            // If there are many photos, allow user to swipe to go to previous/next photo
            if maxPhotoIndex > 0 {
                // Add Swipe
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PostVC.swiped(_:))) // put : at the end of method name
                swipeRight.direction = UISwipeGestureRecognizerDirection.Right
                postImageView.addGestureRecognizer(swipeRight)
                
                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PostVC.swiped(_:))) // put : at the end of method name
                swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
                postImageView.addGestureRecognizer(swipeLeft)
            }
            
            let photo = post.photos[photoIndex]
            
            if photo.fullImage != nil{
                postImageView.image = photo.fullImage
                // Add gesture recognizer immediately
                self.postImageView.addGestureRecognizer(self.longPressRecognizer)
                self.postImageView.addGestureRecognizer(self.tabRecognizer)
            }else{
                postImageView.alpha = 0
                activityIndicator.startAnimating()
                APIBaseClient.sharedInstance.taskForImage(photo.fullUrl){ (imageData, error) in
                    if let data = imageData{
                        dispatch_async(dispatch_get_main_queue()){
                            let image = UIImage(data: data)
                            photo.fullImage = image
                            self.postImageView.image = image
                            self.activityIndicator.stopAnimating()
                            UIView.animateWithDuration(0.3) {
                                self.postImageView.alpha = 1
                            }
                            // Add gesture recognizer only after image is loaded
                            self.postImageView.addGestureRecognizer(self.longPressRecognizer)
                            self.postImageView.addGestureRecognizer(self.tabRecognizer)
                        }
                    }else{
                        dispatch_async(dispatch_get_main_queue()){
                            self.activityIndicator.stopAnimating()
                            UIView.animateWithDuration(0.3) {
                                self.postImageView.alpha = 1
                            }
                            Utilities.displayAlert(self, message: Message.Error.ER009.message)
                        }
                    }
                }
            }
        }else{
            postImageView.hidden = true
        }
        
        // Control the up/down button state
        let index = posts.indexOf(post)!
        if index == 0{
            upButton.enabled = false
        }
        if index == posts.count - 1{
            downButton.enabled = false
        }
    }
    
    // MARK: Segue to next view controller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Use segue to move to post view controller
        if (segue.identifier == "TranslateSegue") {
            let vc = segue.destinationViewController as! TranslateVC
            vc.post = post
            vc.image = postImageView.image
        }
    }
    
    // MARK: Navigate post
    
    @IBAction func upAction(sender: AnyObject) {
        upButton.enabled = true
        downButton.enabled = true
        let previousIndex = posts.indexOf(post)! - 1
        if previousIndex >= 0{
            photoIndex = 0
            post = posts[previousIndex]
            self.viewWillAppear(true)
        }
        if previousIndex == 0 {
            upButton.enabled = false
        }
    }
    @IBAction func downAction(sender: AnyObject) {
        upButton.enabled = true
        downButton.enabled = true
        let nextIndex = posts.indexOf(post)! + 1
        if nextIndex < posts.count{
            photoIndex = 0
            post = posts[nextIndex]
            self.viewWillAppear(true)
        }
        if nextIndex == posts.count - 1 {
            downButton.enabled = false
        }
    }
    
    // MARK: Swipe to change photo
    // http://stackoverflow.com/questions/28696008/swipe-back-and-forth-through-array-of-images-swift
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right :
                print("User swiped right")
                
                // decrease index first
                photoIndex -= 1
                
                // check if index is in range
                if photoIndex < 0 {
                    photoIndex = maxPhotoIndex
                }
                
                // Reload the view
                viewWillAppear(true)
                
            case UISwipeGestureRecognizerDirection.Left:
                print("User swiped Left")
                // increase index first
                photoIndex += 1
                
                // check if index is in range
                if photoIndex > maxPhotoIndex {
                    photoIndex = 0
                }
                
                // Reload the view
                viewWillAppear(true)
                
            default:
                break
            }
        }
    }
}