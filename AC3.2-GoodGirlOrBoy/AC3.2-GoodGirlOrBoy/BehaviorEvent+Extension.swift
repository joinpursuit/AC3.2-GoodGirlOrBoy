//
//  BehaviorEvent+Extension.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

extension BehaviorEvent {
    var dateAndTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date as! Date)
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date as! Date)
    }
    
    var dateString: String {
        let date = self.date!
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let objectDateString = formatter.string(from: date as Date)
        let todayDateString = formatter.string(from: NSDate() as Date)
        if objectDateString == todayDateString {
            return "Today"
        }
        return objectDateString
    }
    var emoji: String {
        if self.behaviorType == "Prosocial" {
            return "😇"
        } else if self.behaviorType == "Antisocial" {
            return "👿"
        }
        return ""
    }

}
