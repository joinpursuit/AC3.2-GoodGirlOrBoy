//
//  Behavior+Addition.swift
//  GoodGirlOrBoy
//
//  Created by Annie Tung on 1/2/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import Foundation

extension Behavior {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        timestamp = NSDate()
    }

    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let timeStampStr = formatter.string(from: timestamp as! Date)
        return "\(timeStampStr)"
    }
}
