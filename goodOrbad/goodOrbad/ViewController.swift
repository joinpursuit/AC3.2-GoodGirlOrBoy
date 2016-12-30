//
//  ViewController.swift
//  goodOrbad
//
//  Created by Amber Spadafora on 12/29/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var children = ["Amber", "Brittney", "Richie"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "child", for: indexPath)
        cell.textLabel?.text = children[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let childVC = segue.destination as? ChildDetailViewController,
            let cell = sender as? UITableViewCell,
            let ip = tableView.indexPath(for: cell) {
            childVC.child = children[ip.row]
        }
    }
    
    
    


}

