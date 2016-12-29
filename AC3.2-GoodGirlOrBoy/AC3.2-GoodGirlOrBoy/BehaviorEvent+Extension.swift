//
//  BehaviorEvent+Extension.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

extension BehaviorEvent {
    var localizedDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date as! Date)
        return "\(self.behaviorType!), \(self.name!), \(dateString)"
    }

}
