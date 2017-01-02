//
//  GoodBoyTableViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit
import CoreData

//enum Behavior {
//    case prosocial
//    case antisocial
//}

enum SortType {
    case name
    case type
    case date
}

class GoodBoyTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let tableView = UITableView()
    let sortTypeSegmentControl = UISegmentedControl(items: ["Date", "Type", "Name"])
    var sortType: SortType = .date
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var fetchedResultsController: NSFetchedResultsController<BehaviorEvent>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        createSegmentControl()
        createNavButtons()
        initializeFetchedResultsController()
        
    }
    
    func createNavButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
    }
 
    func createSegmentControl() {
        self.edgesForExtendedLayout = []
        sortTypeSegmentControl.backgroundColor = .white
        sortTypeSegmentControl.selectedSegmentIndex = 0
        sortTypeSegmentControl.addTarget(self, action: #selector(sortTypeSegemntChanged(_:)), for: .valueChanged)
        sortTypeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sortTypeSegmentControl)
        _ = [
            sortTypeSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortTypeSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortTypeSegmentControl.topAnchor.constraint(equalTo: view.topAnchor),
            sortTypeSegmentControl.heightAnchor.constraint(equalToConstant: 30.0)
            ].map { $0.isActive = true }
    }

    func createTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BehaviorEventTableViewCell.self, forCellReuseIdentifier: "behaviorEventCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        _ = [
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].map { $0.isActive = true }
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<BehaviorEvent> = BehaviorEvent.fetchRequest()
        var sectionName = "date"
        let dateSort = NSSortDescriptor(key: #keyPath(BehaviorEvent.date), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(BehaviorEvent.name), ascending: true)
        let typeSort = NSSortDescriptor(key: #keyPath(BehaviorEvent.behaviorType), ascending: true)
        switch sortType {
        case .date:
            request.sortDescriptors = [dateSort]
            sectionName = "dateString"
        case .name:
            request.sortDescriptors = [nameSort, dateSort]
            sectionName = "name"
        case .type:
            request.sortDescriptors = [typeSort, nameSort, dateSort]
            sectionName = "behaviorType"
        }
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: sectionName, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func addButtonPressed() {
        let addBehaviorVC = AddBehaviorEventViewController()
        if let navVC = self.navigationController {
            navVC.pushViewController(addBehaviorVC, animated: true)
        }
    }
    
    func editButtonPressed() {
        tableView.setEditing(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    func doneButtonPressed() {
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
    }
    
    func sortTypeSegemntChanged(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex {
        case 0:
            sortType = .date
        case 1:
            sortType = .type
        case 2:
            sortType = .name
        default:
            break
        }
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
    
    //MARK: - Tableview Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { fatalError("No sections in fetched results controller") }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetched results controller")
        }
        let sectionInfo = sections[section]
        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { fatalError("No sections in fetched results controller") }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorEventCell", for: indexPath) as! BehaviorEventTableViewCell
        let behaviorEvent = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = behaviorEvent.localizedDescription
        cell.dateLabel.text = behaviorEvent.dateAndTime
        cell.descriptionLabel.text = behaviorEvent.behaviorDescription!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = fetchedResultsController.object(at: indexPath)
            mainContext.delete(object)
            do {
                try mainContext.save()
            } catch let error {
                fatalError("Failed to save context: \(error)")
            }
            
        }
    }

    //MARK: - NSFetchedResultsController Delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
}
