//
//  ProsocialBehavior.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 12/31/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import Foundation

enum ProsocialBehavior: String {
    case Shared = "Shared"
    case CooperatedWithOthers = "Cooperated with Others"
    case VolunteeredToAssist = "Volunteered to Lend a Hand"
    case ShowedEmpathy = "Showed Empathy towards Another"
    case PositiveVerbalEncouragement = "Used Kind, Uplifing Words"
    case KindPhysicalGestures = "Gave a Hug"
    case HelpedToSolveProblem = "Helped Someone Else Cope"
    
    static let proArr = [Shared.rawValue, CooperatedWithOthers.rawValue, VolunteeredToAssist.rawValue, ShowedEmpathy.rawValue, PositiveVerbalEncouragement.rawValue, KindPhysicalGestures.rawValue, HelpedToSolveProblem.rawValue]
}
