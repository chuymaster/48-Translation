//
//  Photo.swift
//  48+ Translation Mockup
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Photo data model
class Photo: NSManagedObject{
    
    @NSManaged var id: String
    @NSManaged var url: String
    @NSManaged var thumbUrl: String
    @NSManaged var fullUrl: String
    @NSManaged var favoriteFlag: Bool
    @NSManaged var post: Post?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext){
        
        // Create entify for this class from CoreData Model
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Set value from dictionary
        id = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as! String
        url = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as! String
        thumbUrl = dictionary["thumbUrl"] as! String
        fullUrl = dictionary["fullUrl"] as! String
        favoriteFlag = false
    }
    
    var thumbImage: UIImage? {
        get {
            let fileName = Constants.General.ThumbnailInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            return Utilities.imageCache.imageWithIdentifier(fileName)
        }
        set {
            let fileName = Constants.General.ThumbnailInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            Utilities.imageCache.storeImage(newValue, withIdentifier: fileName)
        }
    }
    var fullImage: UIImage? {
        get {
            let fileName = Constants.General.FullPhotoInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            return Utilities.imageCache.imageWithIdentifier(fileName)
        }
        set {
            let fileName = Constants.General.FullPhotoInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            Utilities.imageCache.storeImage(newValue, withIdentifier: fileName)
        }
    }
    override func prepareForDeletion() {
        do {
            var fileName = Constants.General.ThumbnailInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            var filePath = Utilities.imageCache.pathForIdentifier(fileName)
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
            fileName = Constants.General.FullPhotoInitial + id + NSURL(string:url)!.lastPathComponent! + Constants.General.PhotoExtension
            filePath = Utilities.imageCache.pathForIdentifier(fileName)
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch _ {}
    }
}
