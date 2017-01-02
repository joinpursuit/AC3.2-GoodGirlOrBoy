//
//  BehaviorLogTableViewController.swift
//  GoodGirlOrBoy
//
//  Created by Madushani Lekam Wasam Liyanage on 12/28/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit
import CoreData

public var fetchedResultsController: NSFetchedResultsController<Entry>!

public var context: NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

public enum GoodOrBad: String {
    case good = "Good"
    case bad = "Bad"
}

class BehaviorLogTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var sectionName = "name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(sectionName: sectionName)
        self.tableView.reloadData()
    }
    
    func getData(sectionName: String) {
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let sort = NSSortDescriptor(key: sectionName, ascending: false)
        request.sortDescriptors = [sort]
        //ascending false - newest one on top
        //request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: nil)
        fetchedResultsController.delegate = self
        
        try! fetchedResultsController.performFetch()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else {
            print("No sections in fetchedResultsController")
            return 0
        }
        print(sections.count)
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorCellIdentifier", for: indexPath) as! BehaviorLogTableViewCell
        cell.goodOrBadImageView.image = nil
        let object = fetchedResultsController.object(at: indexPath)
        
        if sectionName == "name" {
            cell.nameLabel.text = object.formattedDateAndTime
        }
        else if sectionName == "date" {
        cell.nameLabel.text = object.name
        }
        
        cell.descriptionLabel.text = object.behaviorDetail
        
        if object.behavior == "Good" {
            cell.goodOrBadImageView.image = UIImage(named: "Good")
        }
        else {
            cell.goodOrBadImageView.image = UIImage(named: "Bad")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.name
    }
    
    @IBAction func sortSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        if sortSegmentedControl.selectedSegmentIndex == 0 {
            sectionName = "name"
            self.viewDidLoad()
        }
        else if sortSegmentedControl.selectedSegmentIndex == 1 {
            sectionName = "date"
            self.viewDidLoad()
        }
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goodSegueIdentifier" {
            if let acvc = segue.destination as? DetailViewController{
                acvc.behavior = .good
                acvc.title = "Good Behavior Log"
            }
        }
        else if segue.identifier == "badSegueIdentifier" {
            if let acvc = segue.destination as? DetailViewController{
                acvc.behavior = .bad
                acvc.title = "Bad Behavior Log"
            }
        }
    }
    
}

