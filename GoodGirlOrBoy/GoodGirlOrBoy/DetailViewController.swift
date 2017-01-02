//
//  DetailViewController.swift
//  GoodGirlOrBoy
//
//  Created by Madushani Lekam Wasam Liyanage on 12/28/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var namePickerView: UIPickerView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    enum Names: String {
        case sam = "Sam"
        case dan = "Dan"
        case ran = "Ran"
    }
    
    var pickerData: [Names] = [.sam, .dan, .ran]
    var behavior: GoodOrBad?
    var pickedName: String = "Sam"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        namePickerView.dataSource = self
        namePickerView.delegate = self
        
    }
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedName = pickerData[row].rawValue
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let object = Entry(context: context)
        object.name = pickedName
        
        if let text = descriptionTextField.text, let behaviorString = behavior?.rawValue {
            object.date = NSDate()
            object.behavior = behaviorString
            object.behaviorDetail = text
            
        }
        try! context.save()
        
        self.createAlert()
        self.clearAllTextFields()
    }
    
    //http://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
    
    func createAlert() {
        let alert = UIAlertController(title: "Alert", message: "Behavior Log Saved", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //http://stackoverflow.com/questions/25097958/loop-through-subview-to-check-for-empty-uitextfield-swift
    
    func clearAllTextFields() {
        
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.text = ""
            }
        }
        
    }
    
    //http://stackoverflow.com/questions/34955987/pass-data-through-navigation-back-button
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? BehaviorLogTableViewController {
            controller.viewDidLoad()
            controller.tableView.reloadData()
        }
    }
    
}
