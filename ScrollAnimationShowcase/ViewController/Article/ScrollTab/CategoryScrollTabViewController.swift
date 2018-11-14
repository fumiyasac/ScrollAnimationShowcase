//
//  CategoryScrollTabViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/10.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

// カテゴリータブ操作時に実行されるプロトコル
protocol CategoryScrollTabDelegate: NSObjectProtocol {

    // UIPageViewControllerで表示しているインデックスの画面へ遷移する
    func moveToCategoryScrollContents(selectedCollectionViewIndex: Int, targetDirection: UIPageViewController.NavigationDirection, withAnimated: Bool)
}

class CategoryScrollTabViewController: UIViewController {

    //
    weak var delegate: CategoryScrollTabDelegate?
    
    // カテゴリーの一覧データ
    private let categoryList: [String] = ArticleCategoryMock.getArticleCategory()

    // 配置したセル幅の合計値
    private var allTabViewTotalWidth: CGFloat = 0.0

    // 現在選択中のインデックス値を格納する変数(このクラスに配置しているUICollectionViewのIndex番号)
    private var currentSelectIndex = 0

    @IBOutlet weak private var selectedCatogoryUnderlineWidth: NSLayoutConstraint!
    @IBOutlet weak private var categoryScrollTabCollectionView: UICollectionView!

    // MARK: - Computed Properties

    //
    private var targetContentsMaxIndex: Int {
        return categoryList.count - 1
    }

    //
    private var targetCollectionViewCellMaxIndex: Int {
        return categoryList.count * 4 - targetContentsMaxIndex
    }

    //
    private var targetCollectionViewCellMinIndex: Int {
        return categoryList.count
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryScrollTabCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setInitialCategoryScrollTabPosition()
    }

    // MARK: - Function

    //
    func moveToCategoryScrollTab(isIncrement: Bool = true) {

        //
        var targetIndex = isIncrement ? currentSelectIndex + 1 : currentSelectIndex - 1

        //
        if targetIndex > targetCollectionViewCellMaxIndex {
            targetIndex = targetCollectionViewCellMaxIndex - targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMaxIndex
        }

        //
        if targetIndex < targetCollectionViewCellMinIndex {
            targetIndex = targetCollectionViewCellMinIndex + targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMinIndex
        }

        // 押下した場所のインデックス値を持っておく
        currentSelectIndex = targetIndex
        //print("現在のインデックス値:", currentSelectIndex)
        
        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)
    }

    // MARK: - Private Function

    private func setupCategoryScrollTabCollectionView() {
        categoryScrollTabCollectionView.delegate = self
        categoryScrollTabCollectionView.dataSource = self
        categoryScrollTabCollectionView.registerCustomCell(CategoryScrollTabViewCell.self)
        //categoryScrollTabCollectionView.isScrollEnabled = false
        categoryScrollTabCollectionView.showsHorizontalScrollIndicator = false
    }

    private func setInitialCategoryScrollTabPosition() {

        // 押下した場所のインデックス値を持っておくために、実際のタブ個数の2倍の値を設定する
        currentSelectIndex = self.categoryList.count * 2
        print("現在のインデックス値:", currentSelectIndex)

        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: false)
    }

    // 選択もしくはスクロールが止まるであろう位置にあるセルのインデックス値を元にUICollectionViewの位置を更新する
    private func updateCategoryScrollTabCollectionViewPosition(withAnimated: Bool = false) {

        // インデックス値に相当するタブを真ん中に表示させる
        let targetIndexPath = IndexPath(row: currentSelectIndex, section: 0)
        categoryScrollTabCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: withAnimated)

        // UICollectionViewの下線の長さを設定する
        let categoryListIndex = currentSelectIndex % categoryList.count
        setUnderlineWidthFrom(categoryTitle: categoryList[categoryListIndex])

        // 現在選択されている位置に色を付けるためにCollectionViewをリロードする
        categoryScrollTabCollectionView.reloadData()
    }

    // スクロールするタブの下にある下線の幅を文字の長さに合わせて設定する
    private func setUnderlineWidthFrom(categoryTitle: String) {
        let targetWidth = CategoryScrollTabViewCell.calculateCategoryUnderBarWidthBy(title: categoryTitle)
        selectedCatogoryUnderlineWidth.constant = targetWidth
        UIView.animate(withDuration: 0.36, animations: {
            self.view.layoutIfNeeded()
        })
    }

    //
    private func getCategoryScrollContentsDirection(selectedIndex: Int) -> UIPageViewController.NavigationDirection {
        
        //
        if selectedIndex == targetCollectionViewCellMaxIndex - targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMaxIndex {
            return UIPageViewController.NavigationDirection.forward
        }

        //
        if selectedIndex == targetCollectionViewCellMinIndex + targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMinIndex {
            return UIPageViewController.NavigationDirection.reverse
        }

        //
        if currentSelectIndex - selectedIndex > 0 {
            return UIPageViewController.NavigationDirection.reverse
        } else {
            return UIPageViewController.NavigationDirection.forward
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryScrollTabViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension CategoryScrollTabViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // MEMO: 無限スクロールの対象とする場合はタブ表示要素の4倍余分に要素を表示する
        return categoryList.count * 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryScrollTabViewCell.self, indexPath: indexPath)
        let targetIndex = indexPath.row % categoryList.count
        let isSelectedTab = (indexPath.row % categoryList.count == currentSelectIndex % categoryList.count)
        cell.setCategory(name: categoryList[targetIndex], isSelected: isSelectedTab)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //
        let targetDirection = getCategoryScrollContentsDirection(selectedIndex: indexPath.row)

        // 押下した場所のインデックス値を持っておく
        currentSelectIndex = indexPath.row
        print("現在のインデックス値:", currentSelectIndex)
        
        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        //
        self.delegate?.moveToCategoryScrollContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: true
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryScrollTabViewController: UICollectionViewDelegateFlowLayout {

    // タブ用のセルにおける矩形サイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoryScrollTabViewCell.cellSize
    }
}

// MARK: - UIScrollViewDelegate

extension CategoryScrollTabViewController: UIScrollViewDelegate {

    //
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

    // 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // スクロールが停止した際に見えているセルのインデックス値を格納して、真ん中にあるものを取得する
        // 参考: https://stackoverflow.com/questions/18649920/uicollectionview-current-visible-cell-index

        var visibleIndexPathList: [IndexPath] = []
        for cell in categoryScrollTabCollectionView.visibleCells {
            if let visibleIndexPath = categoryScrollTabCollectionView.indexPath(for: cell) {
                visibleIndexPathList.append(visibleIndexPath)
                //print("見えているセルのインデックス値:", visibleIndexPath)
            }
        }
        let targetIndexPath = visibleIndexPathList[1]
        
        // ※この部分は厳密には不要ではあるがdelegeteで引き渡す必要があるので設定している
        let targetDirection = getCategoryScrollContentsDirection(selectedIndex: targetIndexPath.row)

        //
        currentSelectIndex = targetIndexPath.row
        print("現在のインデックス値:", currentSelectIndex)

        // 変数:currentSelectIndexを基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        //
        self.delegate?.moveToCategoryScrollContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: false
        )
    }
}
