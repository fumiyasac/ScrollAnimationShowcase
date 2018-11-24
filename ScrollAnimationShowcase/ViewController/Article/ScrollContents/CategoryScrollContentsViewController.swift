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

    @IBOutlet weak private var desctiptionLabel: UILabel!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryScrollContentsCollectionView()
    }

    // MARK: - Function

    func setDescription(text: String) {
        desctiptionLabel.text = "現在はカテゴリー「\(text)」です😄"
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
        return 18
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryScrollContentsViewCell.self, indexPath: indexPath)
        cell.setCellDecoration()
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Contents", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ContentsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryScrollContentsViewController: UICollectionViewDelegateFlowLayout {

    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryScrollContentsViewCell.getCellSize()
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CategoryScrollContentsViewCell.cellMargin
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CategoryScrollContentsViewCell.cellMargin
    }

    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = CategoryScrollContentsViewCell.cellMargin
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}
