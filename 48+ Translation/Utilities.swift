//
//  Utilities.swift
//  48+ Translation Mockup
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Utilities{
    // Substitute key in url with value
    class func substituteKeyInUrl(url: String, key: String, value: String) -> String? {
        if url.rangeOfString("{\(key)}") != nil {
            return url.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return url
        }
    }
    
    class func displayAlert(vc: UIViewController, message: String, title: String = "Error"){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    class var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Convert Google Plus thumbnail photo url to full size photo url
    // From - https://lh3.googleusercontent.com/-DM_P6oug68E/Vu1W5wnkFQI/AAAAAAAAJSc/SbmsBc5hFXY/w506-h379-n-o/IMG_3506.mp4
    // To - https://lh3.googleusercontent.com/-DM_P6oug68E/Vu1W5wnkFQI/AAAAAAAAJSc/SbmsBc5hFXY/s0/IMG_3506.mp4
    class func convertThumbUrlToFullUrl(thumbUrl: String) -> String{
        if let url = NSURL(string: thumbUrl){
            let fileName = url.lastPathComponent!
            let trimmedUrl = url.URLByDeletingLastPathComponent!
            
            // Replace photo size url component with the fullsize component
            if let newUrl = trimmedUrl.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(Constants.General.GooglePlusFullPhotoSize).URLByAppendingPathComponent(fileName){
                return newUrl.absoluteString
            }else{
                return thumbUrl
            }
        }else{
            return thumbUrl
        }
    }

}