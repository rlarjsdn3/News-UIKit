//
//  NewsArticleTableViewCell.swift
//  News
//
//  Created by 김건우 on 6/2/25.
//

import UIKit

/// 뉴스 기사 정보를 표시하는 셀입니다.
/// 썸네일 이미지, 카테고리, 내용, 작성자, 작성일 등의 정보를 포함합니다.
final class NewsArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    var dataTransferService: (any DataTransferService)?
    private var cancellable: (any NetworkCancellable)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMenu()
        setupIntialState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupIntialState()
    }

    private func setupIntialState() {
        cancellable?.cancel()
        articleImageView.image = nil
        placeholderImageView.isHidden = false
    }

    private func setupMenu() {
        let bookmarkAction = UIAction(
            title: "북마크 추가",
            image: UIImage(systemName: "bookmark")) { _ in
            }

        let shareAction = UIAction(
            title: "공유하기",
            image: UIImage(systemName: "square.and.arrow.up")) { _ in
            }

        let copyLinkAction = UIAction(
            title: "링크 복사",
            image: UIImage(systemName: "link")) { _ in
            }

        let reportAction = UIAction(
            title: "신고하기",
            image: UIImage(systemName: "exclamationmark.bubble"),
            attributes: .destructive) { _ in
            }

        let menu = UIMenu(
            title: "",
            children: [
                bookmarkAction,
                shareAction,
                copyLinkAction,
                reportAction
            ]
        )

        moreButton.apply {
            $0.menu = menu
            $0.showsMenuAsPrimaryAction = true
        }
    }
}

extension NewsArticleTableViewCell {

    /// 주어진 뉴스 기사와 카테고리 정보를 바탕으로 셀의 UI를 구성합니다.
    /// - Parameters:
    ///   - article: 표시할 뉴스 기사 객체
    ///   - category: 선택된 카테고리. nil일 경우 기사 내의 고유 카테고리를 사용합니다.
    func prepare(
        _ article: NewsArticleResponse,
        with category: NewsCategory?
    ) {
        prepareThumbnail(from: article.imageUrl)
        categoryLabel.text = article.refinedCategory(with: category)
        contentLabel.text = article.refinedDescription
        authorLabel.text = article.refinedAuthor
        publishedAtLabel.text = article.formattedPublishedAt
    }

    private func prepareThumbnail(from url: URL?) {
        if let url = url {
            let endpoint = APIEndpoints.image(url)
            cancellable = dataTransferService?.request(endpoint) { [weak self] result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self?.articleImageView.image = image
                        self?.placeholderImageView.isHidden = true
                    } else {
                        self?.articleImageView.isHidden = true
                        self?.placeholderImageView.isHidden = false
                    }
                case .failure(let error):
                    print("thumbnail image download error: \(error)")
                    self?.articleImageView.isHidden = true
                    self?.placeholderImageView.isHidden = false
                }
            }
        } else {
            placeholderImageView.isHidden = false
        }
    }
}

