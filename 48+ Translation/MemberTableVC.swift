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
    
    // NSFetchedResultsController for Member entity
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Member")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: Utilities.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: View Controller Events
    override func viewDidLoad() {
        
        fetchedResultsController.delegate = self
        _fetchMember()
        
        // If no member in database, load new data
        if members.isEmpty{
            _getMember()
        }else{
            NSLog("Member count: \(members.count)")
        }
    }
    
    // Remove and refresh all items
    @IBAction func refreshAction(sender: AnyObject) {
        _fetchMember()
        for member in members{
            Utilities.sharedContext.deleteObject(member)
        }
        Utilities.saveContextInMainQueue()
        _getMember()
    }
    
    private func _getMember(){
        let api = GooglePlusAPIClient()
        api.getMemberList(){ (result, errorString) in
            dispatch_async(dispatch_get_main_queue()){
                if result == false{
                    Utilities.displayAlert(self, message: errorString!)
                }
            }
        }
    }
    
    private func _fetchMember(){
        // Fetch members from database
        do{
            try fetchedResultsController.performFetch()
            members = fetchedResultsController.fetchedObjects as! [Member]
        }catch{
        }
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
        
        configureCell(cell,member: member)
        
        return cell
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: MemberCell, member: Member) {
        
        // Configure cell items
        cell.accessoryType = .DisclosureIndicator
        cell.titleLabel.text = member.displayName
        cell.descriptionTextView.text = member.tagLine
        cell.descriptionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        // Deal with photo download
        if member.image != nil{
            cell.memberImage.image = member.image
        }else{
            cell.memberImage.alpha = 0
            cell.activityIndicator.startAnimating()
            let task = APIBaseClient.sharedInstance.taskForImage(member.imageUrl){ (imageData, error) in
                if let data = imageData{
                    dispatch_async(dispatch_get_main_queue()){
                        let image = UIImage(data: data)
                        member.image = image
                        cell.memberImage.image = image
                        cell.activityIndicator.stopAnimating()
                        UIView.animateWithDuration(0.3) {
                            cell.memberImage.alpha = 1
                        }
                    }
                }
            }
            cell.taskToCancelifCellIsReused = task
        }
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

