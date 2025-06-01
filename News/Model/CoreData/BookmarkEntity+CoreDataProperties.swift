//
//  BookmarkEntity+CoreDataProperties.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//
//

import Foundation
import CoreData


extension BookmarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }

    @NSManaged public var articleId: String?
    @NSManaged public var author: String?
    @NSManaged public var category: [String]?
    @NSManaged public var desc: String?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var link: URL?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?

}

extension BookmarkEntity : Identifiable {

}
