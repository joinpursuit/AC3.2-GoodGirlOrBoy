//
//  BehaviorEvent+Addition.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Ana Ma on 12/28/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import CoreData

extension BehaviorEvent {
    //Call when awake, use as an init method
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        timeStampDate = NSDate()
    }
    
    public override func prepareForDeletion() {
        print("Deleting")
    }
    
    var localizedDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let string = formatter.string(from: timeStampDate! as Date)
        return "\(string)"
    }

}
