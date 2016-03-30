//
//  Post.swift
//  48+ Translation Mockup
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Post data model
class Post: NSManagedObject{
    
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var content: String
    @NSManaged var translatedContent: String
    @NSManaged var url: String
    @NSManaged var publishedAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var favoriteFlag: Bool
    @NSManaged var member: Member?
    @NSManaged var photos: [Photo]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext){
        
        // Create entify for this class from CoreData Model
        let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Set value from dictionary
        id = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as! String
        title = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Title] as! String
        content = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Content] as! String
        url = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as! String
        publishedAt = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Published] as! NSDate
        updatedAt = dictionary[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Updated] as! NSDate
        favoriteFlag = false
    }
 
    var publishedAtString: String{
        // Format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        let dateString = dateFormatter.stringFromDate(publishedAt)
        
        return dateString
    }
    
    var publishedAtDateString: String{
        // Format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        let dateString = dateFormatter.stringFromDate(publishedAt)
        
        return dateString
    }
    
    var updatedAtString: String{
        // Format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        let dateString = dateFormatter.stringFromDate(updatedAt)
        
        return dateString
    }
    
    var updatedAtDateString: String{
        // Format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        let dateString = dateFormatter.stringFromDate(updatedAt)
        
        return dateString
    }
}
