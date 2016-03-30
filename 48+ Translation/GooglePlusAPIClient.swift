//
//  GooglePlusAPIClient.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/24/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Google Plus API client model
class GooglePlusAPIClient : NSObject{
    
    let api = APIBaseClient.sharedInstance
    
    // Get member profiles and save to the CoreDataStackManager
    func getMemberList(checkExisting: Bool, completionHandler:(result:Bool, errorString: String?) -> Void){
        
        var members = [Member]()
        
        if checkExisting{
            // Fetch existing members
            let fetchRequest = NSFetchRequest(entityName: "Member")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext: Utilities.sharedContext,sectionNameKeyPath: nil,cacheName: nil)
            do{
                try fetchedResultsController.performFetch()
                members = fetchedResultsController.fetchedObjects as! [Member]
            }catch{
                NSLog(Message.Error.ER007.message)
            }
        }
        
        // Create new queue to disblock UI update
        var priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)){
            // Error handling
            var _hasError = false
            var _errorString = ""
            
            // Loop through all member id
            for_member: for id in Constants.Database.MemberUserIdList{
                // Create new serial queue on the background thread
                priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_sync(dispatch_get_global_queue(priority, 0)){
                    
                    // Check if member already loaded
                    var _newFlag = true
                    for member in members{
                        dispatch_sync(dispatch_get_main_queue()){
                            if id.id == member.id{
                                _newFlag = false
                            }
                        }
                    }
                    if _newFlag{
                        NSLog("MainThread: \(NSThread.isMainThread())")
                        var _requestFinished = false
                        // Request to API
                        self.getMember(id.id, order: id.order) { (result, errorString) in
                            _requestFinished = true
                            if result == true{
                                NSLog("ID: \(id) Request result: \(result)")
                            }else{
                                NSLog("ID: \(id) Request result: \(result)")
                                _hasError = true
                                _errorString = errorString!
                            }
                        }
                        // Wait until the data is fully retrieve before initiating new API request
                        while _requestFinished == false {
                            continue
                        }
                    }
                }
                if _hasError{
                    completionHandler(result: false, errorString: _errorString)
                    break
                }
            }
            completionHandler(result: true, errorString: nil)
        }
    }
    
    // Get Member Profile
    func getMember(id: String, order: Int, completionHandler:(result: Bool, errorString: String?) -> Void){
        
        let url = getBaseUrl(id)
        
        let keyDictionary = [
            Constants.GooglePlusApi.ParameterKeys.Key: Constants.GooglePlusApi.ParameterValues.Key,
        ]
        
        api.taskForGETMethod(url.absoluteString, headers: [:], parameters: keyDictionary) {(result, error) in
            func completeWithError(error: AnyObject!){
                completionHandler(result: false, errorString: "\(error)")
            }
            if let er = error {
                NSLog("\(er)")
                completeWithError(er.localizedDescription)
                return
            }else{
                print("Member ID: \(id) JSON Result: \(result)")
                // Guard against retrieved data
                guard let
                    id = result[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Id] as? String,
                    name = result[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Name] as? [String: AnyObject],
                    familyName = name[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.FamilyName] as? String,
                    givenName = name[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.GivenName] as? String,
                    memberUrl = result[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Url] as? String,
                    image = result[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Image] as? [String: AnyObject],
                    imageUrl = image[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Url] as? String else{
                        completeWithError(Message.Error.ER006.message)
                        return
                }
                
                // Create new member
                var dictionary: [String: AnyObject] = [
                    Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Id: id,
                    Constants.General.OrderKey: order,
                    Constants.GooglePlusApi.PeopleAPI.ResponseKeys.FamilyName: familyName,
                    Constants.GooglePlusApi.PeopleAPI.ResponseKeys.GivenName: givenName,
                    Constants.GooglePlusApi.PeopleAPI.ResponseKeys.TagLine: "",
                    Constants.GooglePlusApi.PeopleAPI.ResponseKeys.Url: memberUrl,
                    "imageUrl": Utilities.stripQueryFromUrl(imageUrl)
                    ]
                
                // Only some members have tag line
                if let tagLine = result[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.TagLine] as? String{
                    dictionary[Constants.GooglePlusApi.PeopleAPI.ResponseKeys.TagLine] = tagLine
                }
                
                // Update CoreData on the main thread
                dispatch_async(dispatch_get_main_queue()){
                    let member = Member(dictionary: dictionary, context: Utilities.sharedContext)
                    CoreDataStackManager.sharedInstance().saveContext()
                    debugPrint(member)
                }
                
                completionHandler(result: true, errorString: nil)
            }
        }
    }
    
    func getPost(member: Member, checkExisting: Bool, completionHandler:(result: Bool, errorString: String?) -> Void){
        
        var url = getBaseUrl(member.id)
        url = url.URLByAppendingPathComponent(Constants.GooglePlusApi.ActivitiesAPI.AppendPath)
        
        let keyDictionary = [
            Constants.GooglePlusApi.ParameterKeys.Key: Constants.GooglePlusApi.ParameterValues.Key,
            ]
        
        var posts = [Post]()
        
        if checkExisting{
            
            // Fetch existing posts
            let fetchRequest = NSFetchRequest(entityName: "Post")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "member.id == %@", member.id)
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                      managedObjectContext: Utilities.sharedContext,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
            do{
                try fetchedResultsController.performFetch()
                posts = fetchedResultsController.fetchedObjects as! [Post]
            }catch{
                NSLog(Message.Error.ER008.message)
            }
        }
        
        self.api.taskForGETMethod(url.absoluteString, headers: [:], parameters: keyDictionary) {(result, error) in
            func completeWithError(error: AnyObject!){
                completionHandler(result: false, errorString: "\(error)")
            }
            if let er = error {
                NSLog("\(er)")
                completeWithError(er.localizedDescription)
                return
            }else{
                // Get post items
                guard let items = result[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Items] as? [[String: AnyObject]] else{
                    completeWithError(Message.Error.ER006.message)
                    return
                }
                
                for item in items{
                    // Check if post already loaded
                    var _newFlag = true
                    if let id = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as? String{
                        for post in posts{
                            dispatch_sync(dispatch_get_main_queue()){
                                if post.id == id{
                                    _newFlag = false
                                }
                            }
                        }
                        // If it's the new post, create new object
                        if _newFlag{
                            // Get request data
                            if let title = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Title] as? String,
                                content = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Object]?[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Content] as? String,
                                url = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String,
                                publishedAt = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Published] as? String,
                                updatedAt = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Updated] as? String {
                    
                                // Convert string to NSDate
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = Constants.General.DateFormat
                    
                                let published = dateFormatter.dateFromString(publishedAt)!
                                let updated = dateFormatter.dateFromString(updatedAt)!
                        
                                // Replace <br /> in content with \n
                                let formattedContent = content.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
                    
                                // Create new post
                                let postDictionary: [String: AnyObject] = [
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id: id,
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Title: title,
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Content: formattedContent,
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url: url,
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Published: published,
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Updated: updated
                                ]
                        
                                // Update CoreData on the main thread
                                dispatch_async(dispatch_get_main_queue()){
                                    let post = Post(dictionary: postDictionary, context: Utilities.sharedContext)
                                    post.member = member
                                    debugPrint(post)
                                    // Get attachment data to create a photo
                                    if let attachments = item[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Object]?[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Attachments] as? [[String:AnyObject]]{
                                        let attachment = attachments[0] as [String:AnyObject]
                                        let photoDictionary = self.getPhotoDictionary(attachment)
                                        if !photoDictionary.isEmpty{
                                            for dictionary in photoDictionary{
                                                let photo = Photo(dictionary: dictionary, context: Utilities.sharedContext)
                                                photo.post = post
                                                debugPrint(photo)
                                            }
                                        }
                                    }
                                    CoreDataStackManager.sharedInstance().saveContext()
                                }
                            }
                        }
                    }
                }
                completionHandler(result: true, errorString: nil)
            }
        }
    }
    
    func getPhotoDictionary(attachment: [String:AnyObject]) -> [[String:AnyObject]] {
        var photoDictionary = [[String:AnyObject]]()
        
        // Separate type of attachment: album/photo/video to get image url
        if let objectType = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.ObjectType] as? String{
            
            switch objectType{
            // Album
            case Constants.GooglePlusApi.ActivitiesAPI.ResponseValues.ObjectType.Album.rawValue:
                if let
                    id = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as? String,
                    url = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String,
                    thumbnails = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Thumbnails] as? [[String:AnyObject]]{
                    
                    var _counter = 1
                    // Loop through thumbnails
                    for thumbnail in thumbnails{
                        if let image = thumbnail[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Image] as? [String:AnyObject]{
                            if let thumbUrl = image[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String {
                                
                                let newPhotoDictionary = [
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id: "\(id)_\(_counter)",
                                    Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url: url,
                                    "thumbUrl": thumbUrl,
                                    "fullUrl": Utilities.convertThumbUrlToFullUrl(thumbUrl) ] as [String: AnyObject]
                                
                                photoDictionary.append(newPhotoDictionary)
                            }
                        }
                        _counter += 1
                    }
                }
            // Photo
            case Constants.GooglePlusApi.ActivitiesAPI.ResponseValues.ObjectType.Photo.rawValue:
                if let id = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as? String,
                    url = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String,
                    image = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Image] as? [String:AnyObject]{
                    
                    if let thumbUrl = image[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String{
                        
                        let newPhotoDictionary = [
                            Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id: id,
                            Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url: url,
                            "thumbUrl": thumbUrl,
                            "fullUrl": Utilities.convertThumbUrlToFullUrl(thumbUrl) ] as [String: AnyObject]
                        
                        photoDictionary.append(newPhotoDictionary)
                    }
                }
            // Video
            case Constants.GooglePlusApi.ActivitiesAPI.ResponseValues.ObjectType.Video.rawValue:
                if let id = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id] as? String,
                    url = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String,
                    image = attachment[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Image] as? [String:AnyObject]{
                    
                    if let thumbUrl = image[Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url] as? String{
                        
                        let newPhotoDictionary = [
                            Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Id: id,
                            Constants.GooglePlusApi.ActivitiesAPI.ResponseKeys.Url: url,
                            "thumbUrl": thumbUrl,
                            "fullUrl": Utilities.convertThumbUrlToFullUrl(thumbUrl) ] as [String: AnyObject]
                        
                        photoDictionary.append(newPhotoDictionary)
                    }
                }
            default:
                break
            }
        }
        return photoDictionary
    }
    
    // Get base Google+ request url for the member id
    private func getBaseUrl(id: String) -> NSURL {
        
        var url = NSURL(string: Constants.GooglePlusApi.ApiBaseURL)
        url = url!.URLByAppendingPathComponent(Constants.GooglePlusApi.PeopleAPI.AppendPath)
        url = url!.URLByAppendingPathComponent(id)
        
        return url!
    }
}