//
//  TableViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Ana Ma on 12/28/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData

class BehaviorEventManager {
    static let shared: BehaviorEventManager = BehaviorEventManager()
    var behaviorEvents: [NSManagedObject] = []
}

class BehaviorEventTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var behaviorEvents = BehaviorEventManager.shared.behaviorEvents
    
    var controller: NSFetchedResultsController<BehaviorEvent>!
    
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    let cellIdentifier = "behaviorEventCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
        tableView.register(BehaviorEventTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        fetch()
    }
    
    func fetch() {
        let request: NSFetchRequest<BehaviorEvent> = BehaviorEvent.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BehaviorEvent.timeStampDate), ascending: false)]
        controller = NSFetchedResultsController(fetchRequest: request,
                                                managedObjectContext: context,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        controller.delegate = self
        try! controller.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.controller.sections?.count)
        fetch()
        try! controller.performFetch()
        self.tableView.reloadData()
    }
    
    func addButtonPressed() {
        if let navVC = self.navigationController {
            print("NavVC found")
            let inputViewController = InputViewController()
            navVC.pushViewController(inputViewController, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let section = controller.sections {
            print(section.count)
            return section.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let info = sections[section]
            print(info.numberOfObjects)
            return info.numberOfObjects
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! BehaviorEventTableViewCell
        let object = controller.object(at: indexPath)
        cell.nameLabel.text = object.name
        cell.observedBehaviorLabel.text = object.observedBehavior
        cell.qualityOfBehaviorLabel.text = "\(object.qualityOfBehavior)"
        cell.timeStampLabel.text = "\(object.timeStampDate)"
//        cell.textLabel?.text = object.name
//        cell.detailTextLabel?.text = object.observedBehavior
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = controller.object(at: indexPath)
            context.delete(object)
            try! context.save()
        default:
            break
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.reloadData()
    }
}
