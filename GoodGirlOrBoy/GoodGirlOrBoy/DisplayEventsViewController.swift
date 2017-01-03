//
//  DisplayEventsViewController.swift
//  GoodGirlOrBoy
//
//  Created by Sabrina Ip on 1/2/17.
//  Copyright © 2017 Sabrina. All rights reserved.
//

import UIKit
import CoreData

class DisplayEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!

    var fetchedResultsController: NSFetchedResultsController<BehaviorEvent>!
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeFetchedResultsController()
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<BehaviorEvent> = BehaviorEvent.fetchRequest()
        //let sort = NSSortDescriptor(key: "timeStamp", ascending: true)
        var sort = [NSSortDescriptor(key: #keyPath(BehaviorEvent.timeStamp), ascending: false)]
        
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0:
            sort = [NSSortDescriptor(key: #keyPath(BehaviorEvent.timeStamp), ascending: false)]
        case 1:
            sort = [NSSortDescriptor(key: #keyPath(BehaviorEvent.childName), ascending: true)]
        case 2:
            sort = [NSSortDescriptor(key: #keyPath(BehaviorEvent.proSocial), ascending: false),
                    NSSortDescriptor(key: #keyPath(BehaviorEvent.observedBehavior), ascending: false)]
        default:
            break
        }
        
        request.sortDescriptors = sort
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    // MARK: - Actions
    
    @IBAction func filterValueChanged(_ sender: UISegmentedControl) {
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            print("No sections in fetchedResultsController")
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviorEventCell", for: indexPath)
        let object = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(object.childName!) \(object.observedBehavior!)"
//        cell.detailTextLabel?.text = object.localizedDescription
        cell.detailTextLabel?.text = "ok"
        
        if object.proSocial {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // return true to be able to delete things - the default is false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = fetchedResultsController.object(at: indexPath)
            mainContext.delete(object)
            try! mainContext.save()
        default: break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddBehaviorEventViewController
        if segue.identifier == "NegativeBehaviorSelected" {
                destination.proSocial = false
        }
    }
}
