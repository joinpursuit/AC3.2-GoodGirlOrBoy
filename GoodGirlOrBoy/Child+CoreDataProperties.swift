//
//  Child+CoreDataProperties.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 1/1/17.
//  Copyright © 2017 Erica Stevens. All rights reserved.
//

import Foundation
import CoreData


extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child");
    }

    @NSManaged public var name: String?
    @NSManaged public var behaviors: NSOrderedSet?

}

// MARK: Generated accessors for behaviors
extension Child {

    @objc(insertObject:inBehaviorsAtIndex:)
    @NSManaged public func insertIntoBehaviors(_ value: Behavior, at idx: Int)

    @objc(removeObjectFromBehaviorsAtIndex:)
    @NSManaged public func removeFromBehaviors(at idx: Int)

    @objc(insertBehaviors:atIndexes:)
    @NSManaged public func insertIntoBehaviors(_ values: [Behavior], at indexes: NSIndexSet)

    @objc(removeBehaviorsAtIndexes:)
    @NSManaged public func removeFromBehaviors(at indexes: NSIndexSet)

    @objc(replaceObjectInBehaviorsAtIndex:withObject:)
    @NSManaged public func replaceBehaviors(at idx: Int, with value: Behavior)

    @objc(replaceBehaviorsAtIndexes:withBehaviors:)
    @NSManaged public func replaceBehaviors(at indexes: NSIndexSet, with values: [Behavior])

    @objc(addBehaviorsObject:)
    @NSManaged public func addToBehaviors(_ value: Behavior)

    @objc(removeBehaviorsObject:)
    @NSManaged public func removeFromBehaviors(_ value: Behavior)

    @objc(addBehaviors:)
    @NSManaged public func addToBehaviors(_ values: NSOrderedSet)

    @objc(removeBehaviors:)
    @NSManaged public func removeFromBehaviors(_ values: NSOrderedSet)

}
