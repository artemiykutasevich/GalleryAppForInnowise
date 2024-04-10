//
//  CoreDataStack.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 6.04.24.
//

import Foundation
import CoreData

final class CoreDataStack {

    // Properties

    private let modelName: String

    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    // Functions

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                debugPrint("❌ CoreDataStack: storeContainer error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = storeContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            debugPrint("❌ CoreDataStack: saveContext error \(error), \(error.userInfo)")
        }
    }
}
