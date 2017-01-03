//
//  InputViewController.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Ana Ma on 12/29/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import CoreData

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var name = "Angel"
    var timeStamp: NSDate?
    var observedBehavior = "Throwing"
    var qualityOfBehavior = true
    let items = ["Angel", "Brian", "Coral"]
    var observedBehaviorArray = ["Throwing", "Running in the house",
    "Sharing", "Clearing the table", "Finishing dinner", "Hitting", "Saying thank you", "Biting", "Saying You're Welcome", "Apologizing","Doing homework"]
    
    var observedBehaviorPickerView: UIPickerView = UIPickerView()
    var qualityOfBehaviorSwitch: UISwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customSegmentContorl = UISegmentedControl(items: items)
        customSegmentContorl.selectedSegmentIndex = 0
        self.view.backgroundColor = UIColor.green
        
        let frame = UIScreen.main.bounds
        customSegmentContorl.frame = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: frame.height*0.1)
        
        customSegmentContorl.layer.cornerRadius = 5.0
        customSegmentContorl.backgroundColor = UIColor.black
        customSegmentContorl.tintColor = UIColor.white
        
        customSegmentContorl.addTarget(self, action: #selector(changeColor(sender:)), for: .valueChanged)
        
        self.view.addSubview(customSegmentContorl)
        self.view.addSubview(observedBehaviorPickerView)
        self.view.addSubview(qualityOfBehaviorSwitch)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonPressed))
        
        self.observedBehaviorPickerView.dataSource = self
        self.observedBehaviorPickerView.delegate = self
        self.observedBehaviorPickerView.frame = CGRect(x: 0, y: 150, width: self.view.frame.width , height: 162)
        self.observedBehaviorPickerView.backgroundColor = UIColor.blue
        self.observedBehaviorPickerView.layer.borderColor = UIColor.white.cgColor
        self.observedBehaviorPickerView.layer.borderWidth = 1
        
        self.qualityOfBehaviorSwitch.frame = CGRect(x: 100, y: 200, width: 75, height: 25)
    }

    func doneButtonPressed() {
        let behaviorEvent = NSEntityDescription.insertNewObject(forEntityName: "BehaviorEvent", into: context) as! BehaviorEvent
        print(self.name, NSDate(), self.observedBehavior, self.qualityOfBehavior)
        
        behaviorEvent.name = self.name
        behaviorEvent.timeStampDate = NSDate()
        behaviorEvent.observedBehavior = self.observedBehavior
        behaviorEvent.qualityOfBehavior = self.qualityOfBehavior
        
        if context.hasChanges {
            try! context.save()
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
//        let entity = NSEntityDescription.entity(forEntityName: "BehaviorEvent",
//                                                in: context)!
//
//        let behaviorEvent = NSManagedObject(entity: entity,
//                                     insertInto: context) as! BehaviorEvent
//        behaviorEvent.setValue(self.name, forKey: "name")
//        behaviorEvent.setValue(NSDate(), forKey: "timeStampDate")
//        behaviorEvent.setValue(observedBehavior, forKey: "observedBehavior")
//        behaviorEvent.setValue(self.qualityOfBehavior, forKey: "qualityOfBehavior")
        
//        BehaviorEventManager.shared.behaviorEvents.append(behaviorEvent)
        
//        do {
//            try context.save()
//
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.name = self.items[0]
            print("0, \(self.items[0])")
            print(self.name)
            self.view.backgroundColor = UIColor.green
            print("Green")
        case 1:
            self.name = self.items[1]
            print("1, \(self.items[1])")
            print(self.name)
            self.view.backgroundColor = UIColor.blue
            print("Blue")
        default:
            self.name = self.items[2]
            print("2, \(self.items[2])")
            print(self.name)
            self.view.backgroundColor = UIColor.purple
            print("Purple")
        }
    }
    
//    func doneButtonPressed() {
//        //let object = BehaviorEvent(context: context)
//        //object.timeStampDate = NSDate()
//        //object.name = self.name
//        //object.observedBehavior = self.observedBehavior
//        self.context.performAndWait {
//            //let fetchRequest = NSFetchRequest<BehaviorEvent>(entityName: "BehaviorEvent")
//            //let predicate = NSPredicate(format: "title = %@", title)
//            //fetchRequest.predicate = predicate
//            //if let recipeArr = try? fetchRequest.execute(){
//                let event = NSEntityDescription.insertNewObject(forEntityName: "BehaviorEvent", into: self.context) as! BehaviorEvent
//                event.name = self.name
//                event.timeStampDate = NSDate()
//                event.observedBehavior = self.observedBehavior
//                event.qualityOfBehavior = self.qualityOfBehavior ?? true
//            dump(event)
//                self.navigationController?.popViewController(animated: true)
//                self.dismiss(animated: true, completion: nil)
//                
//            //}
//
//        }
//        do {
//            try self.context.save()
//            self.context.parent?.performAndWait {
//                do {
//                    try self.context.parent?.save()
//                }
//                catch {
//                    fatalError("Failure to save context:\(error)")
//                }
//            }
//        }
//        catch let error {
//            print(error)
//        }

        //print(self.controller.sections?.count)
        //self.popoverPresentationController
        //tableView.reloadData()
        //object.qualityOfBehavior =
        //try! controller.performFetch()
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.observedBehaviorArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return observedBehaviorArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.observedBehavior = observedBehaviorArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    @IBAction func observedBehaviorPickerView(sender: AnyObject) {
        print(observedBehaviorPickerView.description)
    }
    
    func qualityOfBehaviorSwitchTapped(sender: UISwitch) {
        if sender == self.qualityOfBehaviorSwitch {
            self.qualityOfBehavior = sender.isOn
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Stamp"
        return label
    }()
    
    lazy var observedBehaviorLabel: UILabel = {
        let label = UILabel()
        label.text = "Observed Behavior"
        return label
    }()
    
    lazy var qualityOfBehaviorLabel: UILabel = {
        let label = UILabel()
        label.text = "Quality Of Behavior"
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        return textField
    }()
    
    lazy var timeStampTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Time Stamp"
        return textField
    }()
    
    lazy var observedBehaviorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Observed Behavior"
        return textField
    }()
    
    lazy var qualityOfBehaviorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Quality Of Behavior"
        return textField
    }()
}
