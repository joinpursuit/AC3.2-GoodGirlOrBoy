//
//  BehaviorEvent+Extension.swift
//  GoodGirlOrBoy
//
//  Created by Sabrina Ip on 12/30/16.
//  Copyright © 2016 Sabrina. All rights reserved.
//

import Foundation

extension BehaviorEvent {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        timeStamp = NSDate()
    }
    
    public override func prepareForDeletion() {
        super.prepareForDeletion()
        print("Deleting object: \(self)")
    }
    
    var localizedDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let string = formatter.string(from: timeStamp! as Date)
        return string
    }
    
}
