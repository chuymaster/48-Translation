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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load image
        if !post.photos.isEmpty{
            postImageView.hidden = false
            let photo = post.photos[0]
            APIBaseClient.sharedInstance().taskForImage(photo.fullUrl){ (imageData, error) in
                if let data = imageData{
                    Utilities.performUIUpdatesOnMain(){
                        let image = UIImage(data: data)
                        self.postImageView.image = image
                        // Add gesture recognizer only after image is loaded
                        self.postImageView.addGestureRecognizer(self.longPressRecognizer)
                        self.postImageView.addGestureRecognizer(self.tabRecognizer)
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

