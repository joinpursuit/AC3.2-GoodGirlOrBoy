//
//  BehaviorTableViewController.swift
//  GoodBoyOrGirl
//
//  Created by Victor Zhong on 12/31/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit
import CoreData

class BehaviorTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Behavior>!
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    let reuseID = "behaviorCells"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<Behavior> = Behavior.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Behavior.date), ascending: false)]
        
        //        This will return an array of objects that match the fetchRequest
        //        try! context.execute(request)
        
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        try! controller.performFetch()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let info: NSFetchedResultsSectionInfo = sections[section]
            return info.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        let object = controller.object(at: indexPath)
        
        var nameString = object.person!

        if object.good {
            nameString += " 😀"
        } else {
            nameString += " 💀"
        }
        
        cell.textLabel?.text = nameString
        
        cell.detailTextLabel?.text = "\(object.activity!) on \(object.easyDate)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = controller.object(at: indexPath)
            context.delete(object)
            try! context.save()
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
