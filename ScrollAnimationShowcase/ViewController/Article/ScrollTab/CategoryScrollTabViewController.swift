//
//  CategoryScrollTabViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/10.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

final class CategoryScrollTabViewController: UIViewController {

    // テスト用のサンプルデータ
    private let dataMock: [String] = [
        "今日のおやつ",
        "週3で通いたい店",
        "お母さんと一緒",
        "ミートクロケット",
        "食後のコーヒー",
        "明日はカツ丼",
    ]

    // 配置したセル幅の合計値
    private var allTabViewTotalWidth: CGFloat = 0.0

    // 現在選択中のインデックス値を格納する変数
    private var currentSelectIndex = 0

    @IBOutlet weak private var selectedCatogoryUnderlineWidth: NSLayoutConstraint!
    @IBOutlet weak private var categoryScrollTabCollectionView: UICollectionView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryScrollTabCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setInitialCategoryScrollTabPosition()
    }

    // MARK: - Private Function

    private func setupCategoryScrollTabCollectionView() {
        categoryScrollTabCollectionView.delegate = self
        categoryScrollTabCollectionView.dataSource = self
        categoryScrollTabCollectionView.registerCustomCell(CategoryScrollTabViewCell.self)
        categoryScrollTabCollectionView.showsHorizontalScrollIndicator = false
    }

    private func setInitialCategoryScrollTabPosition() {

        // 押下した場所のインデックス値を持っておくために、実際のタブ個数の2倍の値を設定する
        currentSelectIndex = self.dataMock.count * 2
        //print("現在のインデックス値:", currentSelectIndex)

        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: false)
    }

    // 選択もしくはスクロールが止まるであろう位置にあるセルのインデックス値を元にUICollectionViewの位置を更新する
    private func updateCategoryScrollTabCollectionViewPosition(withAnimated: Bool = false) {
        // インデックス値に相当するタブを真ん中に表示させる
        let targetIndexPath = IndexPath(row: currentSelectIndex, section: 0)
        categoryScrollTabCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: withAnimated)
        // UICollectionViewの下線の長さを設定する
        setUnderlineWidthFrom(categoryTitle: dataMock[currentSelectIndex % dataMock.count])
    }
    
    private func setUnderlineWidthFrom(categoryTitle: String) {
        let targetWidth = CategoryScrollTabViewCell.calculateCategoryUnderBarWidthBy(title: categoryTitle)
        selectedCatogoryUnderlineWidth.constant = targetWidth
        UIView.animate(withDuration: 0.36, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryScrollTabViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension CategoryScrollTabViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // MEMO: 無限スクロールの対象とする場合はタブ表示要素の4倍余分に要素を表示する
        return dataMock.count * 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryScrollTabViewCell.self, indexPath: indexPath)
        let targetIndex = indexPath.row % dataMock.count
        cell.setCategory(name: dataMock[targetIndex])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // 押下した場所のインデックス値を持っておく
        currentSelectIndex = indexPath.row
        //print("現在のインデックス値:", currentSelectIndex)

        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryScrollTabViewController: UICollectionViewDelegateFlowLayout {

    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryScrollTabViewCell.cellSize
    }
}

// MARK: - UIScrollViewDelegate

extension CategoryScrollTabViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 表示したいセル要素のWidthを計算する
        // MEMO: 実際の幅の値が欲しいのでUIScrollView内の幅を1/4したものになる
        if allTabViewTotalWidth == 0.0 {
            allTabViewTotalWidth = floor(scrollView.contentSize.width / 4.0)
        }

        // スクロールした位置が閾値を超えたら中央に戻す
        if (scrollView.contentOffset.x <= allTabViewTotalWidth) || (scrollView.contentOffset.x > allTabViewTotalWidth * 3.0) {
            scrollView.contentOffset.x = allTabViewTotalWidth * 2.0
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロールが停止した際に見えているセルのインデックス値を格納する
        var visibleIndexPathList: [IndexPath] = []
        for cell in categoryScrollTabCollectionView.visibleCells {
            if let visibleIndexPath = categoryScrollTabCollectionView.indexPath(for: cell) {
                //print("見えているセルのインデックス値:", visibleIndexPath)
                visibleIndexPathList.append(visibleIndexPath)
            }
        }
        currentSelectIndex = visibleIndexPathList[1].row
        //print("現在のインデックス値:", currentSelectIndex)

        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)
    }
}
