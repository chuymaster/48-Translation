//
//  PostTableVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

class PostTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var member: Member!
    var api: GooglePlusAPIClient!
    var posts: [Post]!
    
    override func viewDidLoad() {
        self.title = member.displayName
        //print("\(posts[0].member?.givenName) has \(posts.count) posts")
        
        fetchedResultsController.delegate = self
        api = GooglePlusAPIClient()
        
        // Fetch posts from database
        do{
            try fetchedResultsController.performFetch()
            posts = fetchedResultsController.fetchedObjects as! [Post]
        }catch{}
        
        // If no post in database, load new data
        if posts.isEmpty{
            api.getPost(member, checkExisting: false) { (result, errorString) in
                dispatch_async(dispatch_get_main_queue()){
                    if result == false{
                        Utilities.displayAlert(self, message: errorString!)
                    }
                }
            }
        }else{
            NSLog("Post count: \(posts.count)")
        }
    }
    
    // NSFetchedResultsController for Post entity
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "member.id == %@", "\(self.member.id)")
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: Utilities.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Load new items
    @IBAction func refreshAction(sender: AnyObject) {
        api.getPost(member, checkExisting: true) { (result, errorString) in
            dispatch_async(dispatch_get_main_queue()){
                if result == false{
                    Utilities.displayAlert(self, message: errorString!)
                }
            }
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "PostCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PostCell
        let post = fetchedResultsController.objectAtIndexPath(indexPath) as! Post
        
        configureCell(cell, post: post)
        
        return cell
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: PostCell, post: Post) {
        
        // Configure cell items
        cell.accessoryType = .DisclosureIndicator
        cell.titleLabel.text = post.title
        cell.descriptionLabel.text = post.publishedAtString
        
        // Deal with photo download
        let photos = post.photos
        if !photos.isEmpty{
            
            // Use only the first photo
            let photo = photos[0]
            // Check caches
            if photo.thumbImage != nil{
                cell.postImage.image = photo.thumbImage
            }else{
                cell.postImage.alpha = 0
                cell.activityIndicator.startAnimating()
                let task = APIBaseClient.sharedInstance.taskForImage(photo.thumbUrl){ (imageData, error) in
                    if let data = imageData{
                        dispatch_async(dispatch_get_main_queue()){
                            let image = UIImage(data: data)
                            photo.thumbImage = image
                            cell.postImage.image = image
                            cell.activityIndicator.stopAnimating()
                            UIView.animateWithDuration(0.3) {
                                cell.postImage.alpha = 1
                            }
                            
                        }
                    }
                }
                cell.taskToCancelifCellIsReused = task
            }
        }
    }
    
    
    // MARK: Segue to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Use segue to move to post view controller
        if (segue.identifier == "PostSegue") {
            let vc = segue.destinationViewController as! PostVC
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView?.indexPathForCell(cell)
            let post = fetchedResultsController.objectAtIndexPath(indexPath!) as! Post
            vc.post = post
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    // Content will change
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    // Section changed
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if type == .Insert{
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        }else if type == .Delete{
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        }
    }
    
    // Object changed
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    // Content finished changing
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
