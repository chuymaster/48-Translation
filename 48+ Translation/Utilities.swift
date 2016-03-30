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

/// Class for convenience methods
class Utilities{
    /// Cache for image
    static let imageCache = ImageCache()
    
    /// User preference file path
    static var userPreferenceFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("preference").path!
    }
    
    /// Shared context
    static var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    /**
    Substitute key in url with value
     
    - Parameters:
        - url: URL as string
        - key: key to be substituted
        - value: value to substitute

    - Returns: substituted URL
     */
    static func substituteKeyInUrl(url: String, key: String, value: String) -> String? {
        if url.rangeOfString("{\(key)}") != nil {
            return url.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return url
        }
    }
    
    /**
     Display alert dialogue with a Dismiss button
     
     - Parameters:
     - vc: View Controller
     - message: Alert Message
     - title: Alert title (optional)
     */
    static func displayAlert(vc: UIViewController, message: String, title: String = "Error"){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Save context in main queue
     */
    static func saveContextInMainQueue(){
        dispatch_async(dispatch_get_main_queue()){
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    /**
     Convert Google Plus thumbnail photo url to full size photo url
     Example:
        From - https://lh3.googleusercontent.com/-DM_P6oug68E/Vu1W5wnkFQI/AAAAAAAAJSc/SbmsBc5hFXY/w506-h379-n-o/IMG_3506.mp4
        To - https://lh3.googleusercontent.com/-DM_P6oug68E/Vu1W5wnkFQI/AAAAAAAAJSc/SbmsBc5hFXY/s0/IMG_3506.mp4
     
     - Parameter thumbUrl: Thumbnail image URL
     
     - Returns: Full-size image URL
     */
    static func convertThumbUrlToFullUrl(thumbUrl: String) -> String{
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
    
    /**
     Remove query from the url
     Example:
     From - https://lh3.googleusercontent.com/-dNvFgkld1WE/AAAAAAAAAAI/AAAAAAAAABE/zzg10zkwrvw/photo.jpg?sz=50
     To - https://lh3.googleusercontent.com/-dNvFgkld1WE/AAAAAAAAAAI/AAAAAAAAABE/zzg10zkwrvw/photo.jpg
     
     - Parameter queryUrl: URL string with query
     
     - Returns: URL string without query
     */
    static func stripQueryFromUrl(queryUrl: String) -> String{
        if let url = NSURL(string: queryUrl),
            urlComponent = NSURLComponents(URL: url, resolvingAgainstBaseURL: false){
            urlComponent.query = nil
            return urlComponent.string!
        }else{
            return queryUrl
        }
    }
    
    /**
     Present the UIActivityViewController
     
     - Parameters:
     - vc: View Controller
     - items: Items to pass to the activity
     */
    static func shareItems(vc: UIViewController, items: [AnyObject]) {
        let avc = UIActivityViewController(activityItems: items, applicationActivities: [])
        avc.excludedActivityTypes = [UIActivityTypeOpenInIBooks, UIActivityTypeAssignToContact]
        
        avc.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error:NSError?) in
            if activityType != nil{
                NSLog("Activity: " + activityType!)
            }
            
            // If cancelled
            if (!completed){
                return
            }else{
                // Show complete message if saved to camera roll
                if activityType == UIActivityTypeSaveToCameraRoll{
                    Utilities.displayAlert(vc, message: "Saved photo", title: "Complete")
                }
                return
            }
        }
        // Present the share controller
        vc.presentViewController(avc, animated: true, completion: nil)
    }
}