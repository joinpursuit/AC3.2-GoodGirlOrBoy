//
//  AddBehaviorViewController.swift
//  GoodBoyOrGirl
//
//  Created by Victor Zhong on 12/31/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit
import CoreData

class AddBehaviorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var boyLabel: UILabel!
    @IBOutlet weak var behaviorPicker: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addAction(_ sender: UIButton) {
        acceptButtonPressed()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //Core Data Stuff
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //PickerData Stuff
    var pickerData = [[String]]()
    let boyNames = ["Jason", "Ben", "Louis"]
    let goodBehaviors = ["Gave a 5-Minute Break", "Scheduled a Party", "Assigned a Curve", "Gave Out Cookies"]
    let badBehaviors = ["Assigned HW Late", "Tricky Pop Quiz", "Kicked a Student"]
    
    //Label and Behavior Entity Good Bool stuff
    var selectedBoy = "Who's"
    var selectedActivity = "good"
    var good = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.behaviorPicker.delegate = self
        self.behaviorPicker.dataSource = self
        
        pickerData = [boyNames, goodBehaviors + badBehaviors]
    }
    
    func acceptButtonPressed() {
        let behavior = NSEntityDescription.insertNewObject(forEntityName: "Behavior", into: context) as! Behavior
        behavior.person = boyNames[behaviorPicker.selectedRow(inComponent: 0)]
        behavior.activity = pickerData[1][behaviorPicker.selectedRow(inComponent: 1)]
        behavior.good = good
        behavior.date = NSDate()
        
        if context.hasChanges {
            try! context.save()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    /* Adjusting Font Size via http://stackoverflow.com/questions/7185440/how-to-change-the-font-size-in-uipickerview */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = pickerData[component][row]
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            switch row {
            case 0: badBoyLabel(person: boyNames[0])
            case 1: badBoyLabel(person: boyNames[1])
            default: badBoyLabel(person: boyNames[2])
            }
        }
        
        if component == 1 && row <= goodBehaviors.count - 1 {
            badBoyLabel(goodBehavior: true)
        } else {
            badBoyLabel(goodBehavior: false)
        }
    }
    
    //MARK: - Label Stuff
    
    func updateLabelText() {
        boyLabel.text = "\(selectedBoy) been a \(selectedActivity) boy?"
    }
    
    func badBoyLabel(person: String) {
        selectedBoy = "Has \(person)"
        updateLabelText()
    }
    
    func badBoyLabel(goodBehavior: Bool) {
        if goodBehavior {
            selectedActivity = "good"
            good = true
        }
        else {
            selectedActivity = "bad"
            good = false
        }
        updateLabelText()
    }
}
