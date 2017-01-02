//
//  BehaviorTableViewController.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 12/31/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit
import CoreData

class BehaviorTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    let chooseBehaviorViewController = ChooseBehaviorViewController()
    
    let childrensNames = ["Emily", "Sam"]
    
    var currentChildren: [Child?] = [Child?]()
    
    var currentChild: Child?
    
    var selectedProBehvaior: String?
    var selectedAntiBehavior: String?
    
    let prosocialBlue = UIColor(red: 51.0/255, green: 204.0/255, blue: 255.0/255, alpha: 1)
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    lazy var prosocialView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.prosocialBlue
        
        return view
    }()
    
    lazy var antisocialView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        
        return view
    }()
    
    lazy var prosocialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("PROSOCIAL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(prosocialButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var antisocialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("ANTISOCIAL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(antisocialButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var prosocialPickerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.prosocialBlue
        return view
    }()
    
    lazy var antisocialPickerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    lazy var prosocialPicker: ProsocialPicker = {
       let view = ProsocialPicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.showsSelectionIndicator = true
        return view
    }()
    
    lazy var antisocialPicker: AntisocialPicker = {
        let view = AntisocialPicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.showsSelectionIndicator = true
        return view
    }()
    
    lazy var proImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "ma")
        return view
    }()
    
    lazy var antiImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "LTK58oGTa")
        return view
    }()
    
    lazy var proDoneButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proDoneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var antiDoneButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(antiDoneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let button1 = UIButton()
    let leftItem1 = UIBarButtonItem()
    
    let button2 = UIButton()
    let leftItem2 = UIBarButtonItem()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //insert children into Core Data. Check for duplicates
        for childName in childrensNames {
            let childFetch: NSFetchRequest<Child> = Child.fetchRequest()
            childFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Child.name), childName)
            
            do {
                let results = try managedContext.fetch(childFetch)
                
                if results.count > 0 {
                    let currentChild = results.first!
                    currentChildren.append(currentChild)
                }
                else {
                    let currentChild = Child(context: managedContext)
                    currentChild.name = childName
                    try managedContext.save()
                }
            }
            catch let error as NSError {
                print("Fetch Error: \(error). Description: \(error.userInfo)" )
            }
        }
        
        
        //Nav Bar Stuff
        self.title = ""
        
        button1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button1.backgroundColor = .clear
        button1.setTitle("\(childrensNames[0].characters.first!)", for: .normal)
        button1.setTitleColor(.magenta, for: .normal)
        button1.addTarget(self, action: #selector(trackingChildOne), for: .touchUpInside)
    
        leftItem1.customView = button1
        //leftItem1.style = .plain

        
        button2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button2.addTarget(self, action: #selector(trackingChildTwo), for: .touchUpInside)
        button2.backgroundColor = .clear
        button2.setTitle("\(childrensNames[1].characters.first!)", for: .normal)
        button2.setTitleColor(.blue, for: .normal)
        leftItem2.customView = button2
        //leftItem2.width = 50.0
        print("\n\(childrensNames[1].characters.first)\n")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBehaviorForChildButtonPressed))
        
        self.navigationItem.setLeftBarButtonItems([leftItem1, leftItem2], animated: true)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(navBarBackButtonPressed))
        self.navigationItem.backBarButtonItem = newBackButton
        
        //tableView.reloadData()
        
    }
    
    func navBarBackButtonPressed() {
        print("\nWTF!\n")
         _ = navigationController?.popViewController(animated: true)
    }
    
    
    func trackingChildOne() {
        print("\nPressed Button 1\n")
        currentChild = currentChildren[0]
        self.title = currentChild?.name
        
    }
    
    func trackingChildTwo() {
        print("\nPressed Button 2\n")
        currentChild = currentChildren[1]
        self.title = currentChild?.name
    }
    
    func antiDoneButtonPressed() {
        print("\nBUTTON PRESSED\n")
        
        if let antiBehaviorString = selectedAntiBehavior {
            print(antiBehaviorString)
            let antiConfirmation = UIAlertController(title: "Bad Behavior Noted", message: "\(antiBehaviorString)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                //Add behavior to the child Entity
                if let child = self.currentChild {
                    print(child.name!)
                let antiBehavior = Behavior(context: self.managedContext)
                antiBehavior.child = child
                antiBehavior.timestamp = NSDate()
                antiBehavior.detail = antiBehaviorString
                antiBehavior.isAntisocial = true
                    
                    //Save context
                    do {
                        try self.managedContext.save()
                    } catch let error as NSError {
                        print("Save Error: \(error) \n\nDescription: \(error.userInfo)")
                    }
                }
                
                //Refresh Tableview
                self.tableView.reloadData()
                
                //go back to tableView controller (Refresh results)
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let addAnotherBehaviorAction = UIAlertAction(title: "Add More Bad Behaviors", style: .default, handler: nil)
            
            antiConfirmation.addAction(okAction)
            antiConfirmation.addAction(cancelAction)
            antiConfirmation.addAction(addAnotherBehaviorAction)
            self.present(antiConfirmation, animated: true, completion: nil)
        }
    }
    
    func proDoneButtonPressed() {
        print("\nBUTTON PRESSED\n")
        
        
        if let proBehavior = selectedProBehvaior {
            print("\n\(proBehavior)\n")
            //verify selection
            let proConfirmation = UIAlertController(title: "Good Behavior Noted:", message: "\(proBehavior)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                //go back to tableView controller (Refresh results)
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let addAnotherBehaviorAction = UIAlertAction(title: "Add More Good Behaviors", style: .default, handler: nil)
            
            proConfirmation.addAction(okAction)
            proConfirmation.addAction(cancelAction)
            proConfirmation.addAction(addAnotherBehaviorAction)
            self.present(proConfirmation, animated: true, completion: nil)
        }
    }
    
    func antisocialButtonPressed() {
     
        prosocialView.addSubview(antisocialPickerBackgroundView)
        
        let _ = [
            antisocialPickerBackgroundView.widthAnchor.constraint(equalTo: chooseBehaviorViewController.view.widthAnchor),
            antisocialPickerBackgroundView.heightAnchor.constraint(equalTo: chooseBehaviorViewController.view.heightAnchor, multiplier: 0.5),
            antisocialPickerBackgroundView.topAnchor.constraint(equalTo: chooseBehaviorViewController.view.topAnchor),
            antisocialPickerBackgroundView.leadingAnchor.constraint(equalTo: chooseBehaviorViewController.view.leadingAnchor),
            antisocialPickerBackgroundView.trailingAnchor.constraint(equalTo: chooseBehaviorViewController.view.trailingAnchor),
            antisocialPickerBackgroundView.bottomAnchor.constraint(equalTo: antisocialView.topAnchor)
        ].map{ $0.isActive = true }
        
        antisocialPickerBackgroundView.addSubview(antisocialPicker)
        
        let _ = [
            antisocialPicker.widthAnchor.constraint(equalTo: antisocialPickerBackgroundView.widthAnchor),
            antisocialPicker.heightAnchor.constraint(equalTo: antisocialPickerBackgroundView.heightAnchor),
            antisocialPicker.centerXAnchor.constraint(equalTo: antisocialPickerBackgroundView.centerXAnchor),
            antisocialPicker.centerYAnchor.constraint(equalTo: antisocialPickerBackgroundView.centerYAnchor)
        ].map { $0.isActive = true }
        
        antisocialView.addSubview(antiImageView)
        
        let _ = [
            antiImageView.widthAnchor.constraint(equalToConstant: 100),
            antiImageView.heightAnchor.constraint(equalToConstant: 100),
            antiImageView.centerXAnchor.constraint(equalTo: antisocialView.centerXAnchor),
            antiImageView.topAnchor.constraint(equalTo: antisocialView.topAnchor)
        ].map { $0.isActive = true }
        
        antisocialView.addSubview(antiDoneButton)
        
        let _ = [
            antiDoneButton.heightAnchor.constraint(equalToConstant: 50),
            antiDoneButton.centerXAnchor.constraint(equalTo: antiImageView.centerXAnchor, constant: 5),
            antiDoneButton.topAnchor.constraint(equalTo: antiImageView.topAnchor, constant: 10)
        ].map { $0.isActive = true }
    }
    
    func prosocialButtonPressed() {
        prosocialView.addSubview(proImageView)
        prosocialView.addSubview(proDoneButton)
 
        antisocialView.addSubview(prosocialPickerBackgroundView)
        
        let _ = [
            proDoneButton.heightAnchor.constraint(equalToConstant: 50),
            proDoneButton.topAnchor.constraint(equalTo: proImageView.topAnchor, constant: 20),
            proDoneButton.centerXAnchor.constraint(equalTo: proImageView.centerXAnchor, constant: 5)
            ].map { $0.isActive = true }
        
        
        
        let _ = [
            proImageView.widthAnchor.constraint(equalToConstant: 80),
            proImageView.heightAnchor.constraint(equalToConstant: 80),
            proImageView.centerXAnchor.constraint(equalTo: chooseBehaviorViewController.view.centerXAnchor),
            proImageView.topAnchor.constraint(equalTo: prosocialButton.bottomAnchor, constant: 65)
            ].map { $0.isActive = true }
        
        let _ = [
            prosocialPickerBackgroundView.widthAnchor.constraint(equalTo: chooseBehaviorViewController.view.widthAnchor),
            prosocialPickerBackgroundView.heightAnchor.constraint(equalTo: chooseBehaviorViewController.view.heightAnchor, multiplier: 0.5),
            prosocialPickerBackgroundView.topAnchor.constraint(equalTo: prosocialView.bottomAnchor),
            prosocialPickerBackgroundView.leadingAnchor.constraint(equalTo: chooseBehaviorViewController.view.leadingAnchor),
            prosocialPickerBackgroundView.trailingAnchor.constraint(equalTo: chooseBehaviorViewController.view.trailingAnchor),
            prosocialPickerBackgroundView.bottomAnchor.constraint(equalTo: chooseBehaviorViewController.view.bottomAnchor)
            ].map { $0.isActive = true }
        //pickerView appears populated by enum raw values
        prosocialPickerBackgroundView.addSubview(prosocialPicker)
        
        let _ = [
            prosocialPicker.widthAnchor.constraint(equalTo: prosocialPickerBackgroundView.widthAnchor),
            prosocialPicker.heightAnchor.constraint(equalTo: prosocialPickerBackgroundView.heightAnchor),
            prosocialPicker.centerXAnchor.constraint(equalTo: prosocialPickerBackgroundView.centerXAnchor),
            prosocialPicker.centerYAnchor.constraint(equalTo: prosocialPickerBackgroundView.centerYAnchor)
            ].map {$0.isActive = true}

    }
    
    // MARK: UIPickerViewDelegate/DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case is ProsocialPicker:
            return ProsocialBehavior.proArr.count
        case is AntisocialPicker:
            return AntisocialBehavior.antiArr.count
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case is ProsocialPicker:
            return ProsocialBehavior.proArr[row]
        case is AntisocialPicker:
            return AntisocialBehavior.antiArr[row]
        default:
            return "DEFAULT"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch pickerView {
        case is ProsocialPicker:
            self.selectedProBehvaior = ProsocialBehavior.proArr[row]
            print("Selected Pro Behavior: \(ProsocialBehavior.proArr[row])")
        case is AntisocialPicker:
            self.selectedAntiBehavior = AntisocialBehavior.antiArr[row]
            print("Selected Anti Behavior: \(AntisocialBehavior.antiArr[row])")
        default:
            return
        }
        
        
    }
    
    
    
    
    func addBehaviorForChildButtonPressed() {
        prosocialPickerBackgroundView.removeFromSuperview()
        proImageView.removeFromSuperview()
        antisocialPickerBackgroundView.removeFromSuperview()
        antiImageView.removeFromSuperview()
    
       //new view controller gets pushed on top of stack
        chooseBehaviorViewController.view.backgroundColor = .magenta
        self.navigationController?.pushViewController(chooseBehaviorViewController, animated: true)
        
        //new view prompts user to choose whether behavior was antisocial or prosocal
        
        chooseBehaviorViewController.view.addSubview(prosocialView)
        chooseBehaviorViewController.view.addSubview(antisocialView)
        prosocialView.addSubview(prosocialButton)
        antisocialView.addSubview(antisocialButton)
        
        setupProAntiViewConstraints()
        setupBehaviorButtonConstraints()
        
        //pickerView appears populated by enum
        
        //Once user selects behavior, save to CoreData, 
        
        //refresh and return to tableView Controller (bottom of stack)
    }
    func setupProAntiViewConstraints() {
        let _ = [
            prosocialView.widthAnchor.constraint(equalTo: chooseBehaviorViewController.view.widthAnchor),
            prosocialView.heightAnchor.constraint(equalTo: chooseBehaviorViewController.view.heightAnchor, multiplier: 0.5),
            prosocialView.topAnchor.constraint(equalTo: chooseBehaviorViewController.view.topAnchor),
            prosocialView.leadingAnchor.constraint(equalTo: chooseBehaviorViewController.view.leadingAnchor),
            prosocialView.trailingAnchor.constraint(equalTo: chooseBehaviorViewController.view.trailingAnchor),
            prosocialView.bottomAnchor.constraint(equalTo: antisocialView.topAnchor),
            antisocialView.widthAnchor.constraint(equalTo: chooseBehaviorViewController.view.widthAnchor),
            antisocialView.heightAnchor.constraint(equalTo: chooseBehaviorViewController.view.heightAnchor, multiplier: 0.5),
            antisocialView.bottomAnchor.constraint(equalTo: chooseBehaviorViewController.view.bottomAnchor),
            antisocialView.leadingAnchor.constraint(equalTo: chooseBehaviorViewController.view.leadingAnchor),
            antisocialView.trailingAnchor.constraint(equalTo: chooseBehaviorViewController.view.trailingAnchor),
            antisocialView.topAnchor.constraint(equalTo: prosocialView.bottomAnchor)
            ].map { $0.isActive = true }
    }
    
    func setupBehaviorButtonConstraints() {
        let _ = [
            prosocialButton.widthAnchor.constraint(equalTo: prosocialView.widthAnchor, multiplier: 0.6),
            prosocialButton.heightAnchor.constraint(equalTo: prosocialView.heightAnchor, multiplier: 0.2),
            prosocialButton.centerXAnchor.constraint(equalTo: prosocialView.centerXAnchor),
            prosocialButton.centerYAnchor.constraint(equalTo: prosocialView.centerYAnchor)
            ].map { $0.isActive = true }
        
        let _ = [
            antisocialButton.widthAnchor.constraint(equalTo: antisocialView.widthAnchor, multiplier: 0.6),
            antisocialButton.heightAnchor.constraint(equalTo: antisocialView.heightAnchor, multiplier: 0.2),
            antisocialButton.centerYAnchor.constraint(equalTo: antisocialView.centerYAnchor),
            antisocialButton.centerXAnchor.constraint(equalTo: antisocialView.centerXAnchor)
            ].map { $0.isActive = true }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return 1
        
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let child = currentChild,
            let childName = child.name,
            let childBehaviors = child.behaviors else { return 1 }
        
        switch childName {
        case childName where childName == self.childrensNames[0]:
            return childBehaviors.count
        case childName where childName == self.childrensNames[1]:
            return childBehaviors.count
        default:
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Behavior", for: indexPath)
        
        guard let currentChild = currentChild,
            let behavior = currentChild.behaviors?[indexPath.row] as? Behavior,
            let date = behavior.timestamp as? Date,
        let childName = currentChild.name else { return cell }

        // Configure the cell...
        switch childName {
        case childName where childName == self.childrensNames[0]:
            cell.textLabel?.text = "\(behavior.detail!) \(dateFormatter.string(from: date))"
            return cell
        case childName where childName == self.childrensNames[1]:
            cell.textLabel?.text = "\(behavior.detail!) \(dateFormatter.string(from: date))"
            return cell
        default:
            return cell
        }
       

        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
