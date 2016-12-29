//
//  BehaviorEvent.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 12/29/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation


class BehaviorEvent {
    let type: Behavior
    let date: Date
    let name: String
    
    init(type: Behavior, date: Date, name: String) {
        self.type = type
        self.date = date
        self.name = name
    }
}
