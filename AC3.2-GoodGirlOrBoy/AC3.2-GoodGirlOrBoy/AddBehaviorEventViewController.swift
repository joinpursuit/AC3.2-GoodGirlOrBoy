//
//  AddBehaviorEventViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class AddBehaviorEventViewController: UIViewController, UITextFieldDelegate {
    
    var nameTextField = UITextField()
    var nameLabel = UILabel()
    var behaviorTextField = UITextField()
    var behaviorLabel = UILabel()
    var behaviorTypeSelector = UISegmentedControl(items: ["Prosocial", "Antisocial"])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayViews()
        setConstraints()
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
        nameTextField.borderStyle = .bezel
        behaviorLabel.text = "Description of observed behavior:"
        behaviorTextField.borderStyle = .bezel
        
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
