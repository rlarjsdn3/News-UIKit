//
//  CoreDataService.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

final class CoreDataService {

    static let shared = CoreDataService()
    private init() { }

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("can not load persistent stores: \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("can not save context: \(error), \(error.userInfo)")
            }
        }
    }
}
