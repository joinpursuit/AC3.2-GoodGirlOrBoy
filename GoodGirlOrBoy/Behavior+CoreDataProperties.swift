//
//  Behavior+CoreDataProperties.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 1/1/17.
//  Copyright © 2017 Erica Stevens. All rights reserved.
//

import Foundation
import CoreData


extension Behavior {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Behavior> {
        return NSFetchRequest<Behavior>(entityName: "Behavior");
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var detail: String?
    @NSManaged public var isProsocial: Bool
    @NSManaged public var isAntisocial: Bool
    @NSManaged public var child: Child?

}
