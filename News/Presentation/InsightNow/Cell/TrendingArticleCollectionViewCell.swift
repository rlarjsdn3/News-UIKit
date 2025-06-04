//
//  TrendingArticleCollectionViewCell.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class TrendingArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!

    private var cancellable: (any NetworkCancellable)?
    var dataTransferService: (any DataTransferService)?

    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupIntialState()
    }

    private func setupIntialState() {
        cancellable?.cancel()
        articleImageView.image = nil
        placeholderImageView.isHidden = false
    }
}

extension TrendingArticleCollectionViewCell {
    
    /// 주어진 기사 데이터를 기반으로 셀의 UI를 설정합니다.
    ///
    /// - Parameter article: 셀에 표시할 뉴스 기사 데이터
    func prepare(_ article: NewsArticleResponse) {
        prepareThumbnail(from: article.imageUrl)
        descriptionLabel.text = article.refinedDescription
        authorLabel.text = article.refinedAuthor
        publishedAtLabel.text = article.formattedPublishedAt
    }

    /// 주어진 URL에서 썸네일 이미지를 비동기로 다운로드하고 이미지 뷰에 설정합니다.
    /// 이미지 로드에 실패한 경우 플레이스홀더 이미지를 대신 표시합니다.
    ///
    /// - Parameter url: 로드할 썸네일 이미지의 URL
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
            articleImageView.isHidden = true
            placeholderImageView.isHidden = false
        }
    }
}
