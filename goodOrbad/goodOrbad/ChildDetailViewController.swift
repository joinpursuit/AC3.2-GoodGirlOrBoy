//
//  ChildDetailViewController.swift
//  goodOrbad
//
//  Created by Amber Spadafora on 12/29/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData

class ChildDetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var childsNameLabel: UILabel!
    @IBOutlet weak var behaviorList: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Behavior>!

    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var behaviors: [Behavior] = []
    
    var child: String = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childsNameLabel.text = child
        behaviorList.delegate = self
        behaviorList.dataSource = self
        initializeFetchedResultsController()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addBehaviorVC = segue.destination as? AddBehaviorViewController {
            addBehaviorVC.child = self.child
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            print("No sections in fetchedResultsController")
            return 0
        }
        print(sections.count)
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        if sections.count > 1 {
            if section == 0 {
               return "Positive Behaviors"
            }
            if section == 1 {
                return "Negative Behaviors"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorCell", for: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = fetchedResultsController.object(at: indexPath)
            context.delete(object)
            try! context.save()
        default:
            break
        }
    }
    
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Behavior>(entityName: "Behavior")
        let sort = NSSortDescriptor(key: "wasGood", ascending: false)
        
        request.sortDescriptors = [sort]
        
        let childFilter = self.child
        let predicate = NSPredicate(format: "name == %@", childFilter)
        request.predicate = predicate
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "wasGood", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let behavior = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = behavior.observedBehavior
        guard let date = behavior.date else { return }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let string = formatter.string(from: date as Date)
        
        cell.detailTextLabel?.text = string
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        behaviorList.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            behaviorList.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .update:
            behaviorList.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            behaviorList.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            behaviorList.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            behaviorList.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            behaviorList.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            behaviorList.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        behaviorList.endUpdates()
    }


}
