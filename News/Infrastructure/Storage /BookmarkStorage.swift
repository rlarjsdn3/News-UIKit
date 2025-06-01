//
//  BookmarkStorage.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

protocol BookmarkStorage {
    ///
    func fetchBookmarkArticles() throws -> [NewsArticleResponse]
    ///
    func insertBookmarkArticles(_ article: NewsArticleResponse)
    ///
    func deleteBookmarkArticle(_ article: NewsArticleResponse) throws
}

final class DefaultBookmarkStorage {

    private let coreDataService: CoreDataService
    
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
