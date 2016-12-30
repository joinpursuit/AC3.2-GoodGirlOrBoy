//
//  AddBehaviorViewController.swift
//  goodOrbad
//
//  Created by Amber Spadafora on 12/29/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData

class AddBehaviorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var goodOrBad: UISegmentedControl!
    @IBOutlet weak var behaviorsPicker: UIPickerView!
    
    
    var child: String = String()
    var goodBehaviors: [String] = []
    var badBehaviors: [String] = []
    var goodIndex = 0
    var badIndex = 1
    
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(child)
        self.behaviorsPicker.delegate = self
        self.behaviorsPicker.dataSource = self
        
        
        goodBehaviors = ["did chores", "shared toys", "ate vegetables"]
        badBehaviors = ["didn't share toys", "had a fight", "told a lie"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if goodOrBad.selectedSegmentIndex == goodIndex {
            return goodBehaviors.count
        }
        if goodOrBad.selectedSegmentIndex == badIndex {
            return badBehaviors.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if goodOrBad.selectedSegmentIndex == goodIndex {
            return goodBehaviors[row]
        }
        if goodOrBad.selectedSegmentIndex == badIndex {
            return badBehaviors[row]
        }
        return ""
    }
    
    @IBAction func typeOfBehaviorChosen(_ sender: UISegmentedControl) {
        behaviorsPicker.reloadAllComponents()
    }
    
    
    @IBAction func saveBehavior(_ sender: UIButton) {
        let behaviorInstance: Behavior = Behavior(context: context)
        behaviorInstance.name = child
        behaviorInstance.date = NSDate()
        let selectedBehavior = behaviorsPicker.selectedRow(inComponent: 0)

        if goodOrBad.selectedSegmentIndex == goodIndex {
            behaviorInstance.wasBad = false
            behaviorInstance.wasGood = true
            behaviorInstance.observedBehavior = goodBehaviors[selectedBehavior]
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController!.popViewController(animated: true)
            
        } else {
            behaviorInstance.wasBad = true
            behaviorInstance.wasGood = false
            behaviorInstance.observedBehavior = badBehaviors[selectedBehavior]
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController!.popViewController(animated: true)
            
        }
        
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
