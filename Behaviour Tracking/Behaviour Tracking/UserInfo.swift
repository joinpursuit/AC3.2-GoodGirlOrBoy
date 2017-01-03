//
//  UserInfo.swift
//  Behaviour Tracking
//
//  Created by Tong Lin on 12/30/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class Behav{
    let description: String
    let type: Bool
    init(description: String, type: Bool) {
        self.description = description
        self.type = type
    }
}

let a = Behav(description: "throwing", type: false)
let b = Behav(description: "running in the house", type: false)
let c = Behav(description: "sharing", type: true)
let d = Behav(description: "clearing the table", type: true)
let e = Behav(description: "finishing dinner", type: true)
let f = Behav(description: "hitting", type: false)
let g = Behav(description: "saying thank you", type: true)
let h = Behav(description: "biting", type: false)
let i = Behav(description: "apologizing", type: true)
let j = Behav(description: "doing homework", type: true)

var childs: [String] = ["Amy", "Billy", "Christ"]
var behaviours: [Behav] = [a, b, c, d, e, f, g, h, i, j]
