//
//  NewBehaviourViewController.swift
//  Behaviour Tracking
//
//  Created by Tong Lin on 12/30/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit
import CoreData

class NewBehaviourViewController: UIViewController, NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var selectedName: Int = 0
    var selectedBehav: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAndDismiss))
        view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        addObject()
        addConstraint()
    }
    
    //add objects and setup view
    func addObject(){
        view.addSubview(nameLabel)
        view.addSubview(namePicker)
        view.addSubview(behaviourLabel)
        view.addSubview(behaviourPicker)
        
        namePicker.delegate = self
        namePicker.dataSource = self
        behaviourPicker.delegate = self
        behaviourPicker.dataSource = self
    }
    
    func addConstraint(){
        let nameLabelConstraints = [nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
                                    nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                                    nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)]
        
        let namePickerConstraints = [namePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
                                     namePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                                     namePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                                     namePicker.heightAnchor.constraint(equalToConstant: 130)]
        
        let behaviourLabelConstraints = [behaviourLabel.topAnchor.constraint(equalTo: namePicker.bottomAnchor, constant: 30),
                                         behaviourLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                                         behaviourLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)]
        
        let behaviourPickerConstraints = [behaviourPicker.topAnchor.constraint(equalTo: behaviourLabel.bottomAnchor, constant: 3),
                                          behaviourPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                                          behaviourPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)]
        
        let _ = [nameLabelConstraints, namePickerConstraints, behaviourLabelConstraints, behaviourPickerConstraints].map{ $0.map{ $0.isActive = true }}
    }
    
    func saveAndDismiss(){
        print("dismiss current view")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let pc = appDelegate.persistentContainer
        pc.performBackgroundTask { (context: NSManagedObjectContext) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let newObj = NSEntityDescription.insertNewObject(forEntityName: "Event", into: self.mainContext) as! Event
            newObj.timestamp = NSDate()
            newObj.name = childs[self.selectedName]
            newObj.behaviour = behaviours[self.selectedBehav].description
            newObj.type = behaviours[self.selectedBehav].type
            
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
            
            DispatchQueue.main.async {
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    // MARK: - picker delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case namePicker:
            return childs.count
        default:
            return behaviours.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case namePicker:
            return childs[row]
        default:
            return behaviours[row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case namePicker:
            self.selectedName = row
        default:
            self.selectedBehav = row
        }
    }
    
    
    // MARK: - all objects need in current view
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let behaviourLabel: UILabel = {
        let label = UILabel()
        label.text = "Behaviour"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let namePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let behaviourPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
}
