//
//  Photo.swift
//  48+ Translation Mockup
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation
import CoreData

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
    
}
