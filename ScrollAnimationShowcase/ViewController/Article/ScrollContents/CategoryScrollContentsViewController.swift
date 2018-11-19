//
//  CategoryContentsViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/13.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class CategoryScrollContentsViewController: UIViewController {

    @IBOutlet weak private var categoryScrollContentsCollectionView: UICollectionView!

    // MEMO: 後に実際のものに差し替える
    @IBOutlet weak private var sampleTitleLabel: UILabel!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryScrollContentsCollectionView()
    }

    // MARK: - Function

    func setTitle(text: String) {
        sampleTitleLabel.text = "現在表示しているIndex値：\(text)"
    }

    // MARK: - Private Function

    private func setupCategoryScrollContentsCollectionView() {
        categoryScrollContentsCollectionView.delegate = self
        categoryScrollContentsCollectionView.dataSource = self
        categoryScrollContentsCollectionView.registerCustomCell(CategoryScrollContentsViewCell.self)
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryScrollContentsViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension CategoryScrollContentsViewController: UICollectionViewDataSource {

    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryScrollContentsViewCell.self, indexPath: indexPath)
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
