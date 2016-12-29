//
//  GoodBoyTableViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit
import CoreData

enum Behavior {
    case prosocial
    case antisocial
}

class GoodBoyTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var behaviorEvents: [Int] = []
    var tableView = UITableView()
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<BehaviorEvent>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        createNavButtons()
        initializeFetchedResultsController()
    }
    
    func createNavButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(minusButtonPressed))
    }
    
    func createTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "behaviorCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        _ = [
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].map { $0.isActive = true }
        
    }
    
    func initializeFetchedResultsController() {
        // switch on filter type
        
        let request: NSFetchRequest<BehaviorEvent> = BehaviorEvent.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(BehaviorEvent.date), ascending: false)
        request.sortDescriptors = [dateSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
        
    
    func addButtonPressed() {
        print("add")
        //addBehaviorEvent(behaviorType: "😇")
        let addBehaviorVC = AddBehaviorEventViewController()
        addBehaviorVC.navigationController?.title = "😇"
        if let navVC = self.navigationController {
            navVC.pushViewController(addBehaviorVC, animated: true)
        }
    }
    
    func minusButtonPressed() {
        print("minus")
        addBehaviorEvent(behaviorType: "👿")
    }
    
    func addBehaviorEvent(behaviorType: String) {
        let newObject = BehaviorEvent(context: mainContext)
        newObject.behaviorType = behaviorType
        newObject.name = "Tom"
        newObject.behaviorDescription = "Tom was a naughty boy"
        newObject.date = NSDate()
        do {
            try mainContext.save()
        }
        catch let error {
            fatalError("Failed to save context: \(error)")
        }

    }
    
    
    //MARK: - Tableview Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { fatalError("No sections in fetched results controller") }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { fatalError("No sections in fetched results controller") }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorCell", for: indexPath)
        let behaviorEvent = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = behaviorEvent.localizedDescription
        return cell
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
