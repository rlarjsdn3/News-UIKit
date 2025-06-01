//
//  CoreDataService.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    ///
    case readError(any Error)
    ///
    case saveError(any Error)
    ///
    case deleteError(any Error)
}

final class CoreDataService {
    
    /// <#Description#>
    static let shared = CoreDataService()
    private init() { }
    
    /// <#Description#>
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// <#Description#>
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("can not load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    /// <#Description#>
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
    
    /// <#Description#>
    /// - Parameter block: <#block description#>
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

extension CoreDataService {
    
    /// <#Description#>
    /// - Parameters:
    ///   - predicate: <#predicate description#>
    ///   - sortDescriptors: <#sortDescriptors description#>
    /// - Returns: <#description#>
    func fetch<Entity>(
        _ predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [Entity] where Entity: NSManagedObject {
        let request = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try viewContext.fetch(request)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - entity: <#entity description#>
    ///   - viewContext: <#viewContext description#>
    func insert<Entity>(
        _ entity: Entity,
        insertInto viewContext: NSManagedObjectContext? = nil
    ) where Entity: NSManagedObject {
        let viewContext = viewContext ?? self.viewContext
        viewContext.insert(entity)
        saveContext()
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - entity: <#entity description#>
    ///   - keyPath: <#keyPath description#>
    ///   - value: <#value description#>
    func update<Entity, Value>(
        _ entity: Entity,
        by keyPath: ReferenceWritableKeyPath<Entity, Value>,
        to value: Value
    ) where Entity: NSManagedObject {
        entity[keyPath: keyPath] = value
        saveContext()
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - entity: <#entity description#>
    ///   - viewContext: <#viewContext description#>
    func delete<Entity>(
        _ entity: Entity,
        deleteFrom viewContext: NSManagedObjectContext? = nil
    ) where Entity: NSManagedObject {
        let viewContext = viewContext ?? self.viewContext
        viewContext.delete(entity)
        saveContext()
    }
}

//
