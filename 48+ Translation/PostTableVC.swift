//
//  PostTableVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

/// Post table view controller class
class PostTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var member: Member!
    var api: GooglePlusAPIClient!
    var posts: [Post]!
    var loadingFlag: Bool = false
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = member.displayName
        if member.favoriteFlag{
            likeButton.image = UIImage(named: Constants.Image.StarFilled)
        }else{
            likeButton.image = UIImage(named: Constants.Image.StarBlank)
        }
        
        fetchedResultsController.delegate = self
        api = GooglePlusAPIClient()
        showLoading()
        
        // Fetch posts from database
        fetchPosts()
        
        // Load new post if no data
        var _checkExisting = true
        if posts.isEmpty{
            _checkExisting = false
        }
        api.getPost(member, checkExisting: _checkExisting) { (result, errorString) in
            // Wait until loading alert completed showing
            while self.loadingFlag == false{
                continue
            }
            self.dismissViewControllerAnimated(false){
                self.loadingFlag = false
                if result == false{
                    Utilities.displayAlert(self, message: errorString!)
                }
            }
        }
    }
    
    // MARK: View controller functions
    
    /// Show alert indicating loading progress
    func showLoading(){
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true){
            self.loadingFlag = true
        }
    }
    
    func fetchPosts(){
        do{
            try fetchedResultsController.performFetch()
            posts = fetchedResultsController.fetchedObjects as! [Post]
        }catch{}
    }
    
    @IBAction func likeMember(sender: AnyObject) {
        member.favoriteFlag = !member.favoriteFlag
        Utilities.saveContextInMainQueue()
        if member.favoriteFlag{
            likeButton.image = UIImage(named: Constants.Image.StarFilled)
        }else{
            likeButton.image = UIImage(named: Constants.Image.StarBlank)
        }
    }
    
    // MARK: - Table View Delegate
    
    // Disable Edit operation
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
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
            fetchPosts()
            vc.posts = posts
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
