//
//  CoreDataService.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

/// Core Data 작업 중 발생할 수 있는 오류를 나타내는 열거형입니다.
enum CoreDataError: Error {

    /// 데이터를 읽는 도중 발생한 오류
    case readError(any Error)

    /// 데이터를 저장하는 도중 발생한 오류
    case saveError(any Error)

    /// 데이터를 삭제하는 도중 발생한 오류
    case deleteError(any Error)
}

/// Core Data 관련 기능을 캡슐화한 싱글톤 서비스 클래스입니다.
/// 컨텍스트 접근, 저장, 백그라운드 작업 수행 등을 제공합니다.
final class CoreDataService {

    /// CoreDataService의 싱글톤 인스턴스입니다.
    static let shared = CoreDataService()
    private init() { }

    /// 메인 스레드에서 사용할 기본 viewContext입니다.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// `NSPersistentContainer`는 앱의 Core Data Stack을 캡슐화하며,
    /// 컨텍스트와 영속 저장소를 관리합니다.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("can not load persistent stores: \(error)")
            }
        }
        return container
    }()

    /// viewContext에 변경사항이 있는 경우 저장을 시도합니다.
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

    /// 백그라운드에서 Core Data 작업을 안전하게 수행합니다.
    /// - Parameter block: 백그라운드 컨텍스트를 이용한 작업을 수행하는 클로저
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

extension CoreDataService {
    
    /// 주어진 조건과 정렬 기준을 기반으로 Core Data 엔티티를 조회합니다.
    /// - Parameters:
    ///   - predicate: 조회 조건을 정의하는 NSPredicate. 기본값은 nil로, 모든 객체를 조회합니다.
    ///   - sortDescriptors: 정렬 기준을 정의하는 배열. 기본값은 nil로 정렬하지 않습니다.
    /// - Returns: 조건을 만족하는 Entity 객체 배열
    /// - Throws: fetch 요청 실패 시 오류를 던집니다.
    func fetch<Entity>(
        _ predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [Entity] where Entity: NSManagedObject {
        let request = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try viewContext.fetch(request)
    }

    /// 지정된 엔티티 객체를 Core Data 컨텍스트에 삽입합니다.
    /// - Parameters:
    ///   - entity: 삽입할 NSManagedObject 서브클래스 인스턴스
    ///   - viewContext: 삽입에 사용할 NSManagedObjectContext. 지정하지 않으면 기본 viewContext가 사용됩니다.
    func insert<Entity>(
        _ entity: Entity,
        insertInto viewContext: NSManagedObjectContext? = nil
    ) where Entity: NSManagedObject {
        let viewContext = viewContext ?? self.viewContext
        viewContext.insert(entity)
        saveContext()
    }

    /// 주어진 엔티티의 특정 키 경로에 값을 설정하고, 변경 사항을 저장합니다.
    /// - Parameters:
    ///   - entity: 값을 수정할 NSManagedObject 인스턴스
    ///   - keyPath: 수정할 속성의 키 경로 (ReferenceWritableKeyPath)
    ///   - value: 지정할 새로운 값
    func update<Entity, Value>(
        _ entity: Entity,
        by keyPath: ReferenceWritableKeyPath<Entity, Value>,
        to value: Value
    ) where Entity: NSManagedObject {
        entity[keyPath: keyPath] = value
        saveContext()
    }

    /// 주어진 엔티티를 지정된 컨텍스트에서 삭제하고, 변경 사항을 저장합니다.
    /// - Parameters:
    ///   - entity: 삭제할 NSManagedObject 인스턴스
    ///   - viewContext: 삭제 작업에 사용할 NSManagedObjectContext. 지정하지 않으면 기본 viewContext가 사용됩니다.
    func delete<Entity>(
        _ entity: Entity,
        deleteFrom viewContext: NSManagedObjectContext? = nil
    ) where Entity: NSManagedObject {
        let viewContext = viewContext ?? self.viewContext
        viewContext.delete(entity)
        saveContext()
    }
}
