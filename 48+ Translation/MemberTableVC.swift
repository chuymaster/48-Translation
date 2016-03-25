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
    
    var members: [Member] = [Member]()
    
    override func viewDidLoad() {
        
        fetchedResultsController.delegate = self
        
        do{
            // Fetch members from database and add to the map
            try self.fetchedResultsController.performFetch()
            members = self.fetchedResultsController.fetchedObjects as! [Member]
            print("Member Count:\(members.count)")
        }catch{}
        
        if members.count == 0{
            getPeople()
        }else{
            print(members)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    // NSFetchedResultsController for Member entity
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Member")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: Utilities.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    func getPeople(){
        let api = GooglePlusAPIClient()
        for id in Constants.Database.MemberUserIdList{
            api.getMember(id){ (result, errorString) in
                print("\(id) request result: \(result)")
                
                Utilities.performUIUpdatesOnMain(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // Use sectionInfo from NSResultsController instead
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "MemberCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        let member = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
        
        cell.textLabel?.text = "\(member.familyName)\(member.givenName)"
        cell.detailTextLabel?.text = member.tagLine
        APIBaseClient.sharedInstance().taskForImage(member.imageUrl){ (imageData, error) in
            if error == nil{
                Utilities.performUIUpdatesOnMain(){
                    let image = UIImage(data: imageData!)
                    cell.imageView?.image = image
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMember = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PostList") as! PostTableVC
        vc.posts = selectedMember.posts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Remove the Pin from Core Data
//            let member = fetchedResultsController.objectAtIndexPath(indexPath) as! Member
//            Utilities.sharedContext.deleteObject(member)
//            CoreDataStackManager.sharedInstance().saveContext()
//        }
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
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
            
            let member = fetchedResultsController.objectAtIndexPath(indexPath!) as! Member
            
            cell.textLabel?.text = "\(member.familyName)\(member.givenName)"
            cell.detailTextLabel?.text = member.tagLine
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    // Content finished changing
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

}

