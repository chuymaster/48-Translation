//
//  PostVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

class PostVC: PostBaseVC, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load image
        if !post.photos.isEmpty{
            postImageView.hidden = false
            let photo = post.photos[0]
            if photo.fullImage != nil{
                postImageView.image = photo.fullImage
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
                    }
                }
            }
        }else{
            postImageView.hidden = true
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
    
}

