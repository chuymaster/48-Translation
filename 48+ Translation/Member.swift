//
//  Member.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Member data model
class Member: NSManagedObject{
    
    @NSManaged var id: String
    @NSManaged var order: NSNumber
    @NSManaged var familyName: String
    @NSManaged var givenName: String
    @NSManaged var tagLine: String
    @NSManaged var url: String
    @NSManaged var imageUrl: String
    @NSManaged var favoriteFlag: Bool
    @NSManaged var posts: [Post]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext){
        
        // Create entify for this class from CoreData Model
        let entity = NSEntityDescription.entityForName("Member", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Set value from dictionary
        id = dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Id] as! String
        order = dictionary[Constants.General.OrderKey] as! NSNumber
        familyName = dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.FamilyName] as! String
        givenName = dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.GivenName] as! String
        tagLine = dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.TagLine] as! String
        url = dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Url] as! String
        imageUrl = dictionary["imageUrl"] as! String
        favoriteFlag = false
    }
    
    var displayName: String {
        return "\(familyName)\(givenName)"
    }
    
    var image: UIImage? {
        get {
            let fileName = id + "_" + (NSURL(string: imageUrl)?.lastPathComponent)!
            return Utilities.imageCache.imageWithIdentifier(fileName)
        }
        set {
            let fileName = id + "_" + (NSURL(string: imageUrl)?.lastPathComponent)!
            Utilities.imageCache.storeImage(newValue, withIdentifier: fileName)
        }
    }
}
