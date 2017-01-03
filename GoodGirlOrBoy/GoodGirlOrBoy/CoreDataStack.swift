//
//  CoreDataStack.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 12/31/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import Foundation
import CoreData

//Source: "Core Data by Tutorials" Chapter 3: Core Data Stack
class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let nsError = error as NSError? {
                print("\nUnresolved error: \(nsError), \(nsError.userInfo)\n")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("\nUnresolved error: \(error), \(error.userInfo)\n")
        }
    }
}
