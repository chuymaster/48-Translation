//
//  MemberTableVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

class MemberTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Class Variables
    var members: [Member] = [Member]()
    @IBOutlet var memberTableView: UITableView!
    var api: GooglePlusAPIClient!
    
    // NSFetchedResultsController for Member entity
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Member")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "familyName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: Utilities.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: View Controller Events
    override func viewDidLoad() {
        
        fetchedResultsController.delegate = self
        api = GooglePlusAPIClient()
        
        // Fetch members from database
        do{
            try fetchedResultsController.performFetch()
            members = fetchedResultsController.fetchedObjects as! [Member]
        }catch{
        }
        
        // If no member in database, load new data
        if members.isEmpty{
            api.getMemberList()
        }else{
            print("Member count: \(members.count)")
        }
    }
    
    // Remove and refresh all items
    @IBAction func refreshAction(sender: AnyObject) {
        do{
            try fetchedResultsController.performFetch()
            members = fetchedResultsController.fetchedObjects as! [Member]
            for member in members{
                Utilities.sharedContext.deleteObject(member)
            }
            Utilities.performUIUpdatesOnMain(){
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }catch{
        }
        api.getMemberList()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "MemberCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MemberCell
        
        let member = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
        
        cell.accessoryType = .DisclosureIndicator
        cell.titleLabel.text = member.displayName
        cell.descriptionTextView.text = member.tagLine
        // Scroll textview to the top
        cell.descriptionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        cell.memberImage.contentMode = .ScaleAspectFill
        
        let task = APIBaseClient.sharedInstance.taskForImage(member.imageUrl){ (imageData, error) in
            if let data = imageData{
                Utilities.performUIUpdatesOnMain(){
                    let image = UIImage(data: data)
                    cell.memberImage.image = image
                }
            }
        }
        cell.taskToCancelifCellIsReused = task
        return cell
    }
    
    // Disable Delete operation
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Use segue to move to post list view controller
        if (segue.identifier == "PostsSegue") {
            let vc = segue.destinationViewController as! PostTableVC
            let cell = sender as! UITableViewCell
            let indexPath = memberTableView.indexPathForCell(cell)
            let member = fetchedResultsController.objectAtIndexPath(indexPath!) as! Member
            vc.member = member
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

