//
//  TrendingNowCollectionViewCell.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class TrendingNowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var dataTransferService: (any DataTransferService)?
    
    var trendingArticles: [NewsArticleResponse] = [] {
        didSet { collectionView.reloadData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupAttributes()
    }
    
    private func setupAttributes() {
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        print(#function)
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        print(#function)
    }
}

extension TrendingNowTableViewCell: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        NotificationCenter.default.post(
            name: .didTapTrendingArticleCell,
            object: nil,
            userInfo: [.indexPath: indexPath]
        )
    }
}

extension TrendingNowTableViewCell: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return trendingArticles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingArticleCollectionViewCell.id,
            for: indexPath
        ) as! TrendingArticleCollectionViewCell
        let targetArticle = trendingArticles[indexPath.item]
        item.dataTransferService = dataTransferService
        item.prepare(targetArticle)
        return item
    }
}

extension TrendingNowTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 360, height: 405)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 18.0
    }
}
