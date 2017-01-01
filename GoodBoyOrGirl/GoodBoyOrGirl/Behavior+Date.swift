//
//  Behavior+Date.swift
//  GoodBoyOrGirl
//
//  Created by Victor Zhong on 12/31/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

extension Behavior {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date = NSDate()
    }
    
    var easyDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date! as Date)
    }
}
