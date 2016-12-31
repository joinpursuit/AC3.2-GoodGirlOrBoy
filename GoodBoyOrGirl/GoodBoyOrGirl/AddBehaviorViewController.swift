//
//  AddBehaviorViewController.swift
//  GoodBoyOrGirl
//
//  Created by Victor Zhong on 12/31/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class AddBehaviorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var behaviorPicker: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    var pickerData = [[String]]()
    let goodBehaviors = ["Gave a 5-Minute Break", "Scheduled a Party", "Assigned a Curve", "Gave Out Cookies"]
    let badBehaviors = ["Assigned HW Late", "Tricky Pop Quiz", "Kicked a Student"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.behaviorPicker.delegate = self
        self.behaviorPicker.dataSource = self
        
        pickerData = [["Jason", "Ben", "Louis"], goodBehaviors + badBehaviors]
        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    /* Adjusting Font Size with reference from http://stackoverflow.com/questions/7185440/how-to-change-the-font-size-in-uipickerview */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil)
            
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = pickerData[component][row]
        
        return pickerLabel!
    }
}
