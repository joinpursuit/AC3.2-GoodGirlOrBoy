//
//  BehaviorTableViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by C4Q on 12/31/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData


class BehaviourTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let cellID = "Behavior Cell"
    
    let behaviors = ["throwing",
                     "running in the house",
                     "sharing",
                     "clearing the table",
                     "finishing dinner",
                     "hitting",
                     "saying thank you",
                     "biting",
                     "apologizing",
                     "doing homework"]
    
    let kids = [ "Tom",
                 "Hari",
                 "Jermaine"]
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    private var controller: NSFetchedResultsController<BehaviourEvent>!
    let request: NSFetchRequest<BehaviourEvent> = BehaviourEvent.fetchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BehaviourEvent.time), ascending: false)]
        controller = NSFetchedResultsController(fetchRequest: request,
                                                managedObjectContext: context,
                                                sectionNameKeyPath: #keyPath(BehaviourEvent.childName),
                                                cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(sender:)), name: NSNotification.Name(rawValue: "post"), object: nil)
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }

    func reloadData(sender: NSNotification){
        do {
            try controller.performFetch()
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections  = controller.sections else {
            return 0
        }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = controller.sections,
            section < sections.count,
            let objects = sections[section].objects else {
                return 0
        }
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let object = controller.object(at: indexPath)
        cell.textLabel?.text = object.childName!
        print("section: ", controller.sections![indexPath.section].name,"name: ", object.childName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, MMMM dd, yyyy"
        let date = formatter.string(from: object.time as! Date)
        let goodOrEvil = object.thisIsPositiveBehaviour ? "👼" : "👹"
        
        
        cell.detailTextLabel?.text = object.behavior! + " " + date + " " + goodOrEvil
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = controller.sections else { return  "Error" }
        let object = sections[section]
        return object.name
    }
    
    func addButtonPressed(sender: UIBarButtonItem) {
        let view = BehaviourEntryViewController()
        self.present(view, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .update:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
