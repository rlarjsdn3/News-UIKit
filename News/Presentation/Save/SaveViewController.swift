//
//  SaveViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit
import CoreData

final class SaveViewController: CoreViewController {

    @IBOutlet weak var bookmarksTableView: UITableView!

    private let dataTrasnferService: any DataTransferService = DefaultDataTransferService()

    private lazy var fetchedResultsController = bookmarkStorage.fetchedResultController
    private let bookmarkStorage: any BookmarkStorage = DefaultBookmarkStorage()

    ///
    private var bookmarks: [NewsArticleResponse] = [] {
        didSet { bookmarksTableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        performFetchBookmarkEntities()
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let vc = segue.destination as? ArticleDetailViewController,
           let indexPath = bookmarksTableView.indexPathForSelectedRow  {
            vc.article = bookmarks[indexPath.row]
        }
    }

    override func setupAttributes() {
        fetchedResultsController.delegate = self

        bookmarksTableView.apply {
            $0.register(
                UINib(nibName: "NewsArticleTableViewCell", bundle: nil),
                forCellReuseIdentifier: NewsArticleTableViewCell.id
            )
            $0.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }

    private func performFetchBookmarkEntities() {
        do {
            try fetchedResultsController.performFetch()
            refreshBookmarkEntities()
        } catch {
            print(error)
        }
    }

    private func refreshBookmarkEntities() {
        if let entities = fetchedResultsController.fetchedObjects {
            bookmarks = entities.map { $0.toNewsArticleResponse() }
        }
    }
}

extension SaveViewController {

}

extension SaveViewController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        refreshBookmarkEntities()
    }
}

extension SaveViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: "navigateToArticleDetail",
            sender: nil
        )
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
}

extension SaveViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsArticleTableViewCell.id,
            for: indexPath
        ) as! NewsArticleTableViewCell
        let targetArticle = bookmarks[indexPath.row]
        cell.dataTransferService = dataTrasnferService
        cell.prepare(targetArticle, with: nil)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 160.0
    }
}
