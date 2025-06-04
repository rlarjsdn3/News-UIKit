//
//  BookmarkStorage.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

/// 북마크된 기사 데이터를 저장, 조회, 삭제할 수 있는 기능을 정의한 프로토콜입니다.
protocol BookmarkStorage {

    /// 북마크 엔티티를 실시간으로 관찰할 수 있는 Fetched Results Controller입니다.
    var fetchedResultController: NSFetchedResultsController<BookmarkEntity> { get }

    /// Core Data에서 북마크된 기사 목록을 가져옵니다.
    /// - Returns: 변환된 NewsArticleResponse 배열
    func fetchBookmarkArticles() throws -> [NewsArticleResponse]

    /// 지정된 기사를 북마크 목록에 추가합니다.
    /// - Parameter article: 추가할 뉴스 기사
    func insertBookmarkArticles(_ article: NewsArticleResponse)

    /// 지정된 기사를 북마크 목록에서 삭제합니다.
    /// - Parameter article: 삭제할 뉴스 기사
    func deleteBookmarkArticle(_ article: NewsArticleResponse) throws
}

/// BookmarkStorage 프로토콜을 구현한 기본 북마크 저장소 구현체입니다.
/// Core Data를 기반으로 북마크 데이터를 관리합니다.
final class DefaultBookmarkStorage {

    /// 내부에서 사용하는 Core Data 서비스 인스턴스입니다.
    private let coreDataService: CoreDataService

    /// 북마크 엔티티를 가져오기 위한 NSFetchedResultsController입니다.
    /// 게시일(publishedAt) 기준으로 내림차순 정렬되며, fetchBatchSize는 20입니다.
    lazy var fetchedResultController: NSFetchedResultsController<BookmarkEntity> = {
        let request = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \BookmarkEntity.publishedAt, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = 20

        let resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataService.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return resultsController
    }()

    /// 주어진 Core Data 서비스를 이용해 북마크 저장소를 초기화합니다.
    /// - Parameter coreDataService: Core Data 관련 작업을 수행할 서비스. 기본값은 공유 인스턴스입니다.
    init(coreDataService: CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
}

extension DefaultBookmarkStorage: BookmarkStorage {

    func fetchBookmarkArticles() throws -> [NewsArticleResponse] {
        do {
            let entities: [BookmarkEntity] = try coreDataService.fetch()
            return entities.map { $0.toNewsArticleResponse() }
        } catch {
            throw CoreDataError.readError(error)
        }
    }

    func insertBookmarkArticles(_ article: NewsArticleResponse) {
        let entity = BookmarkEntity(
            article,
            insertInto: coreDataService.viewContext
        )
        coreDataService.insert(entity)
    }

    func deleteBookmarkArticle(_ article: NewsArticleResponse) throws {
        do {
            let entites: [BookmarkEntity] = try coreDataService.fetch()
            if let entity = entites.first(where: { $0.articleId == article.articleId }) {
                coreDataService.delete(entity)
            }
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }
}
