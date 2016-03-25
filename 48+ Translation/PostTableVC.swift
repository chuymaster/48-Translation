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
    
    var posts: [Post]!
    
    override func viewDidLoad() {
        print("\(posts[0].member?.givenName) has \(posts.count) posts")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Use sectionInfo from NSResultsController instead
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "PostCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        let post = posts[indexPath.row]
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        let dateString = dateFormatter.stringFromDate(post.publishedAt)
        
        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = post.title
        
        let photos = post.photos
        if !photos.isEmpty {
            let photo = photos[0]
            APIBaseClient.sharedInstance().taskForImage(photo.thumbUrl){ (imageData, error) in
                if error == nil{
                    Utilities.performUIUpdatesOnMain(){
                        let image = UIImage(data: imageData!)
                        cell.imageView?.image = image
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedPost = posts[indexPath.row]
//        
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PostList") as! PostTableVC
//        vc.posts = selectedMember.posts
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}