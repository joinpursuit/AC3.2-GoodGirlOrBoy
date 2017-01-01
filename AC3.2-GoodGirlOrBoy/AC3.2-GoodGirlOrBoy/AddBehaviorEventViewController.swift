//
//  AddBehaviorEventViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit
import CoreData

class AddBehaviorEventViewController: UIViewController, UITextFieldDelegate {
    
    var nameTextField = UITextField()
    var nameLabel = UILabel()
    var behaviorTextField = UITextField()
    var behaviorLabel = UILabel()
    var behaviorTypeSelector = UISegmentedControl(items: ["Prosocial", "Antisocial"])
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayViews()
        setConstraints()
        createNavButtons()
    }
    
    func createNavButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
    }
    
    func saveButtonPressed() {
        if let name = nameTextField.text, name.characters.count > 0,
            let description = behaviorTextField.text, description.characters.count > 0,
            let type = behaviorTypeSelector.titleForSegment(at: behaviorTypeSelector.selectedSegmentIndex) {
            
            let newObject = BehaviorEvent(context: mainContext)
            newObject.behaviorType = type
            newObject.name = name
            newObject.behaviorDescription = description
            newObject.date = NSDate()
            do {
                try mainContext.save()
            }
            catch let error {
                fatalError("Failed to save context: \(error)")
            }
            let alert = UIAlertController(title: "Success", message: "Behavior Event Added Successfully", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                _ = self.navigationController?.popViewController(animated: true) }
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Name and Description fields must be filled in correctly", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func displayViews() {
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        behaviorLabel.translatesAutoresizingMaskIntoConstraints = false
        behaviorTextField.translatesAutoresizingMaskIntoConstraints = false
        behaviorTypeSelector.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Name:"
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocorrectionType = .no
        behaviorLabel.text = "Description of observed behavior:"
        behaviorTextField.borderStyle = .roundedRect
        behaviorTypeSelector.selectedSegmentIndex = 0
        
        self.view.addSubview(nameTextField)
        self.view.addSubview(nameLabel)
        self.view.addSubview(behaviorTextField)
        self.view.addSubview(behaviorLabel)
        self.view.addSubview(behaviorTypeSelector)
    }
    
    func setConstraints() {
        _ = [
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            behaviorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            behaviorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            behaviorTextField.topAnchor.constraint(equalTo: behaviorLabel.bottomAnchor, constant: 8.0),
            behaviorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            behaviorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            behaviorTypeSelector.topAnchor.constraint(equalTo: behaviorTextField.bottomAnchor, constant: 8.0),
            behaviorTypeSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ].map { $0.isActive = true }
        
    }

   
}
