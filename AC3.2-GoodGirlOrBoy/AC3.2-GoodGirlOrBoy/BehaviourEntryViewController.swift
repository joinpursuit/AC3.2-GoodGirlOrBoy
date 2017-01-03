//
//  BehaviorEntryViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by C4Q on 12/31/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData

class BehaviourEntryViewController: UIViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    var nameTextField = UITextField()
    var behaviourTextField = UITextField()
    var doneButton =  UIButton()
    var isThisPositiveSwitch = UISwitch()
    var isThisPositiveLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpTextFields()
        setUpDoneButton()
        setUpPositivity()
    }
    
    func setUpPositivity() {
        self.isThisPositiveLabel.text = "This is a positive \n behaviour: \(isThisPositiveSwitch.isOn.description)"
        self.isThisPositiveLabel.translatesAutoresizingMaskIntoConstraints = false
        self.isThisPositiveLabel.adjustsFontSizeToFitWidth = true
        self.isThisPositiveLabel.numberOfLines = 0
        self.view.addSubview(isThisPositiveLabel)
        
        self.isThisPositiveSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.isThisPositiveSwitch.addTarget(self, action: #selector(switchTouched(sender:)), for: .valueChanged)
        self.view.addSubview(isThisPositiveSwitch)
        
        let labelConstraints = [
            isThisPositiveLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4.0),
            isThisPositiveLabel.topAnchor.constraint(equalTo: behaviourTextField.bottomAnchor, constant: 16.0),
            isThisPositiveLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8.0)
            ]
        
        let switchConstraints = [
            isThisPositiveSwitch.leadingAnchor.constraint(equalTo: isThisPositiveLabel.trailingAnchor, constant: 8.0),
            isThisPositiveSwitch.centerYAnchor.constraint(equalTo: isThisPositiveLabel.centerYAnchor)
        ]
        
        _ = [labelConstraints, switchConstraints].map { $0.map { $0.isActive = true } }
        
    }
    
    func switchTouched (sender: UISwitch) {
        self.isThisPositiveLabel.text = "This is a positive behaviour: \(sender.isOn.description)"
    }
    
    func setUpDoneButton () {
        self.doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.titleLabel?.textColor = .white
        self.doneButton.backgroundColor = .lightGray
        self.doneButton.layer.cornerRadius = 10.0
        
        
        self.view.addSubview(doneButton)
        
        _ = [
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            doneButton.widthAnchor.constraint(equalToConstant: 55.0)
            ].map { $0.isActive = true }
    }
    
    func setUpTextFields () {
        self.nameTextField.delegate = self
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField.placeholder = "Enter Name"
        self.view.addSubview(nameTextField)
        
        self.behaviourTextField.delegate = self
        self.behaviourTextField.translatesAutoresizingMaskIntoConstraints = false
        self.behaviourTextField.placeholder = "Enter Behaviour"
        self.view.addSubview(behaviourTextField)
        
        let nameConstraints = [
            nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 150.0),
            nameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ]
        let behaviourConstraints = [
            behaviourTextField.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
            behaviourTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20.0),
            behaviourTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor)
        ]
        
        _ = [nameConstraints, behaviourConstraints].map { $0.map { $0.isActive = true } }
    }
    
    func doneButtonPressed (sender: UIBarButtonItem) {
        if let name = nameTextField.text,
            let behaviour = behaviourTextField.text,
            name.characters.count >= 1,
            behaviour.characters.count >= 1 {
            let entry = BehaviourEvent(context: context)
            entry.populate(name: name, behaviour: behaviour, positiveBehaviour: isThisPositiveSwitch.isOn)
            do {
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        self.dismiss(animated: true) { self.parent?.reloadInputViews() }
    }
}
