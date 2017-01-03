//
//  BehaviourEntry+Extension.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by C4Q on 12/31/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

extension BehaviourEvent {
    func populate (name: String, behaviour: String, positiveBehaviour: Bool) {
        self.behavior = behaviour
        self.childName = name
        self.time = NSDate()
        self.thisIsPositiveBehaviour = positiveBehaviour
    }
}
