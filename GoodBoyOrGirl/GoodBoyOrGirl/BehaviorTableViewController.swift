//
//  BehaviorTableViewController.swift
//  GoodBoyOrGirl
//
//  Created by Victor Zhong on 12/31/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit
import CoreData

class BehaviorTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filterPicker: UIPickerView!
    
    let filters = [["All Boys", "Ben", "Louis", "Jason"], ["All Behaviors","Good", "Bad"], ["All Dates","Today"]]
    
    var controller: NSFetchedResultsController<Behavior>!
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    let reuseID = "behaviorCells"
    var personPredicatePick = "all"
    var behaviorPredicatePick = "all"
    var datePredicatePick = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterPicker.delegate = self
        self.filterPicker.dataSource = self
        
        fetchThis()
    }
    
    func fetchThis(personCheck: String = "all", behaviorCheck: String = "all", dateCheck: String = "all") {
        
        let request: NSFetchRequest<Behavior> = Behavior.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Behavior.date), ascending: false)]
        
        var predicateArray = [NSPredicate]()
        
        /* Finding Midnight via http://stackoverflow.com/questions/26189656/how-can-i-set-an-nsdate-object-to-midnight */
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let newDate = cal.startOfDay(for: date)
        
        if personCheck != "all" {
            predicateArray.append(NSPredicate(format: "person == %@", personCheck))
        }
        
        if behaviorCheck != "all" {
            predicateArray.append(NSPredicate(format: "good == \(behaviorCheck)"))
        }
        
        if dateCheck != "all" {
            predicateArray.append(NSPredicate(format: "date >= %@", newDate as CVarArg))
        }
        
        if personCheck != "all" || behaviorCheck != "all" || dateCheck != "all" {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
        }
        
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
    
    //MARK: - PickerView Stuff
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return filters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filters[component].count
    }
    
    /* Adjusting Font Size with reference from http://stackoverflow.com/questions/7185440/how-to-change-the-font-size-in-uipickerview */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = filters[component][row]
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            switch row {
            case 0: personPredicatePick = "all"
            case 1: personPredicatePick = filters[0][1]
            case 2: personPredicatePick = filters[0][2]
            case 3: personPredicatePick = filters[0][3]
            default: break
            }
        }
        
        if component == 1 {
            switch row {
            case 0: behaviorPredicatePick = "all"
            case 1: behaviorPredicatePick = "YES"
            case 2: behaviorPredicatePick = "NO"
            default: return
            }
        }
        
        if component == 2 {
            switch row {
            case 0: datePredicatePick = "all"
            case 1: datePredicatePick = "today"
            default: return
            }
        }
        
        fetchThis(personCheck: personPredicatePick, behaviorCheck: behaviorPredicatePick, dateCheck: datePredicatePick)
        tableView.reloadData()
    }
}
