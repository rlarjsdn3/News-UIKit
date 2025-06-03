//
//  ArticleTableView.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class ArticleTableView: UITableView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.apply {
            $0.register(
                UINib(nibName: "NewsArticleTableViewCell", bundle: nil),
                forCellReuseIdentifier: NewsArticleTableViewCell.id
            )
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
}
