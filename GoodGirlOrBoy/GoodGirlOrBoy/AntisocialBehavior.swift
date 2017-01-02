//
//  AntisocialBehavior.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 1/1/17.
//  Copyright © 2017 Erica Stevens. All rights reserved.
//

import Foundation

enum AntisocialBehavior: String {
    case Stole = "Caught Stealing"
    case WasDecietfulOrSneaky = "Was Decietful or Sneaky"
    case UsedMeanLanguage = "Used Mean Language"
    case HitSibling = "Hit Sibling (or me!)"
    case DidNotFollowInstructions = "Did Not Follow Instructions"
    case ThrewTantrum = "Threw Tantrum"
    case Selfishness = "Was Unnecessarily Selfish"
    case DestroyedProperty = "Destroyed Physical Things"
    
    static let antiArr = [Stole.rawValue, WasDecietfulOrSneaky.rawValue, UsedMeanLanguage.rawValue, HitSibling.rawValue, DidNotFollowInstructions.rawValue, ThrewTantrum.rawValue, Selfishness.rawValue, DestroyedProperty.rawValue]
}
