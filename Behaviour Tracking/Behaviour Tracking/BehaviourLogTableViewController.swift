//
//  BehaviourLogTableViewController.swift
//  Behaviour Tracking
//
//  Created by Tong Lin on 12/29/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit
import CoreData

let cellIdentifier = "MyCell"
class BehaviourLogTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var myfilter: [String: String?] = ["child": nil, "type": nil, "day": nil]
    
    var context: NSManagedObjectContext!
    static var fetchedResultsController: NSFetchedResultsController<Event>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBehaviour))
        let predicateBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addPredicate))
        
        initializeFetchedResultsController()
        self.navigationItem.title = "History"
        self.edgesForExtendedLayout = []
        self.navigationItem.rightBarButtonItems = [addBarButton, predicateBarButton]
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupFilterView()
        //tableView.tableHeaderView = optionsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeFetchedResultsController()
        self.tableView.reloadData()
    }

    func addBehaviour(){
        let add = NewBehaviourViewController()
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    func addPredicate(){
        tableView.tableHeaderView = (tableView.tableHeaderView == nil) ? optionsView : nil
    }
    
    func setupFilterView(){
        optionsView.addSubview(childSegments)
        optionsView.addSubview(typeSegments)
        
        addConstraint()
    }
    
    func addConstraint(){
        
        let childSegmentsConstraints = [childSegments.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 10),
                                      childSegments.centerXAnchor.constraint(equalTo: optionsView.centerXAnchor)]
        
        let typeSegmentsConstraints = [typeSegments.topAnchor.constraint(equalTo: childSegments.bottomAnchor, constant: 15),
                                        typeSegments.centerXAnchor.constraint(equalTo: optionsView.centerXAnchor)]
        
        let _ = [childSegmentsConstraints, typeSegmentsConstraints].map{ $0.map{ $0.isActive = true } }
    }
    
    func predicateUpdate(){
        print("apply predicate and reload table view")
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        
        BehaviourLogTableViewController.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        BehaviourLogTableViewController.fetchedResultsController.delegate = self
        
        do {
            try BehaviourLogTableViewController.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = BehaviourLogTableViewController.fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = BehaviourLogTableViewController.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let object = BehaviourLogTableViewController.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = object.textForCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = BehaviourLogTableViewController.fetchedResultsController.object(at: indexPath)
            
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            context.delete(object)
            do {
                try context.save()
            } catch _ {
                print("unable to delete object in core data")
            }
            initializeFetchedResultsController()
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    
    let optionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
        return view
    }()
    
    let childSegments: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        for name in childs.reversed(){
            control.insertSegment(withTitle: name, at: 0, animated: false)
        }
        control.insertSegment(withTitle: "All", at: 0, animated: false)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(predicateUpdate), for: .valueChanged)
        return control
    }()
    
    let typeSegments: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.insertSegment(withTitle: "Antisocial", at: 0, animated: false)
        control.insertSegment(withTitle: "Prosocial", at: 0, animated: false)
        control.insertSegment(withTitle: "All", at: 0, animated: false)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(predicateUpdate), for: .valueChanged)
        return control
    }()
    
}





