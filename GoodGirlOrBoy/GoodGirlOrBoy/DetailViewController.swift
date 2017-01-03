//
//  DetailViewController.swift
//  GoodGirlOrBoy
//
//  Created by Annie Tung on 1/2/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var myLabel: UILabel!
    
    // MARK: - Properties
    
    var prosocial = true
    var pickerData: [[String]] = []
    var childrensNames = ["Annie", "Ben", "Charlie"]
    var goodBehaviors = ["sharing", "clearing the table", "finishing dinner", "saying thank you", "apologizing", "doing homework"]
    var badBehaviors = ["throwing", "running in the house", "hitting", "biting", "yelling", "not cleaning up"]
    
    // MARK: - Core Data
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPicker.delegate = self
        myPicker.dataSource = self
        myLabel.text = "What was the behavior?"
        setupButton()
        if prosocial {
            myLabel.text = "Select the pro-social behavior"
            pickerData = [childrensNames, goodBehaviors]
        } else {
            myLabel.text = "Select the anti-social behavior"
            pickerData = [childrensNames, badBehaviors]
        }
    }
    
    // MARK: - Button Actions
    
    func saveButtonTapped(sender: UIButton) {
        let behavior = NSEntityDescription.insertNewObject(forEntityName: "Behavior", into: context) as! Behavior
        behavior.name = pickerData[0][myPicker.selectedRow(inComponent: 0)]
        behavior.observedBehavior = pickerData[1][myPicker.selectedRow(inComponent: 1)]
        behavior.behavior = prosocial
        behavior.timestamp = NSDate()
        
        if context.hasChanges {
            try! context.save()
        }
        let alert = UIAlertController(title: "Great!", message: "Behavior has been saved", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setupButton() {
        let saveButton: UIButton = UIButton(type: UIButtonType.system)
        self.view.addSubview(saveButton)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(sender:)), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
            ].map {$0.isActive = true}
    }
 
    // MARK: - UIPicker
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
