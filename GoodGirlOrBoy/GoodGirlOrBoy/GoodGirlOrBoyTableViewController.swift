//
//  GoodGirlOrBoyTableViewController.swift
//  GoodGirlOrBoy
//
//  Created by Annie Tung on 1/2/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit
import CoreData

class GoodGirlOrBoyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Behavior>!
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Good Girl or Boy?"
        initializeFetchResults()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
//        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Initialize Fetch Results Controller
    
    func initializeFetchResults() {
        let request: NSFetchRequest<Behavior> = Behavior.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Behavior.timestamp), ascending: false)]
        
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        try! controller.performFetch()
    }
    
    // MARK: - Button Action
    
    func addButtonTapped() {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        print("Error populating number of sections")
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let info: NSFetchedResultsSectionInfo = sections[section]
            return info.numberOfObjects
        }
        print("Error populating number of rows in section")
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviorCell", for: indexPath)

        let object = controller.object(at: indexPath)
        var behavior = object.observedBehavior!
        if object.behavior {
            behavior += "👍🏻😇"
        } else {
            behavior += "👎🏻👿"
        }
        cell.textLabel?.text = "\(object.name!) \(behavior)"
        cell.detailTextLabel?.text = object.formattedTimestamp
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = controller.sections else {
            fatalError("Error populating title for header in section")
        }
        let sectionInfo = sections[section]
        return sectionInfo.name
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
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        if segue.identifier == "antisocialBehaviorSelected" {
            destination.prosocial = false
        }
    }

}
