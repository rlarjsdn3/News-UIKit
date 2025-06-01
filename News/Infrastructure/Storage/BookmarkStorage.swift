//
//  BookmarkStorage.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

protocol BookmarkStorage {
    ///
    var fetchedResultController: NSFetchedResultsController<BookmarkEntity> { get }
    ///
    func fetchBookmarkArticles() throws -> [NewsArticleResponse]
    ///
    func insertBookmarkArticles(_ article: NewsArticleResponse)
    ///
    func deleteBookmarkArticle(_ article: NewsArticleResponse) throws
}

final class DefaultBookmarkStorage {

    private let coreDataService: CoreDataService

    ///
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

    /// <#Description#>
    /// - Parameter coreDataService: <#coreDataService description#>
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
