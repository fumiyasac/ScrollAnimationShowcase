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

    // CategoryScrollTabDelegateプロトコル
    weak var delegate: CategoryScrollTabDelegate?

    // カテゴリーの一覧データ
    private let categoryList: [String] = ArticleCategoryMock.getArticleCategory()

    // ボタン押下時の軽微な振動を追加する
    private let buttonFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    // 配置したセル幅の合計値
    private var allTabViewTotalWidth: CGFloat = 0.0

    // 現在選択中のインデックス値を格納する変数(このクラスに配置しているUICollectionViewのIndex番号)
    private var currentSelectIndex = 0

    @IBOutlet weak private var selectedCatogoryUnderlineWidth: NSLayoutConstraint!
    @IBOutlet weak private var categoryScrollTabCollectionView: UICollectionView!

    // MARK: - Computed Properties

    // MEMO:
    // ここでは無限スクロールができるように予め、(実際の個数 × 4)のセルを配置している
    // またscrollViewDidScroll内の処理で所定の位置で調整をかけるので実際のUICollectionViewCellのインデックス値の範囲は下記のようになる
    // Ex. タブを6個設定する場合 → 6 ... 19が取り得る範囲となる

    // 表示するカテゴリーの個数を元にしたインデックスの最大値
    // 例. カテゴリーが6個の場合は5となる
    private var targetContentsMaxIndex: Int {
        return categoryList.count - 1
    }

    // 実際に配置したUICollectionViewCellが取り得るインデックスの最大値
    // 例. カテゴリーが6個の場合は19となる
    private var targetCollectionViewCellMaxIndex: Int {
        return categoryList.count * 4 - targetContentsMaxIndex
    }

    // 実際に配置したUICollectionViewCellが取り得るインデックスの最小値
    // 例. カテゴリーが6個の場合は6となる
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

    // 親(ArticleViewController)のUIPageViewControllerのスクロール方向を元にUICollectionViewの位置を設定する
    // MEMO: このメソッドはUIPageViewControllerを配置している親(ArticleViewController)から実行される
    func moveToCategoryScrollTab(isIncrement: Bool = true) {

        // UIPageViewControllerのスワイプ方向を元に、更新するインデックスの値を設定する
        var targetIndex = isIncrement ? currentSelectIndex + 1 : currentSelectIndex - 1

        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMaxIndex)を超えた場合は補正をする
        if targetIndex > targetCollectionViewCellMaxIndex {
            targetIndex = targetCollectionViewCellMaxIndex - targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMaxIndex
        }

        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMinIndex)を下回った場合は補正をする
        if targetIndex < targetCollectionViewCellMinIndex {
            targetIndex = targetCollectionViewCellMinIndex + targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMinIndex
        }

        // 押下した場所のインデックス値を持っておく
        currentSelectIndex = targetIndex
        //print("コンテンツ表示側のインデックスを元にした現在のインデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
    }

    // MARK: - Private Function

    // UICollectionViewに関する設定
    private func setupCategoryScrollTabCollectionView() {
        categoryScrollTabCollectionView.delegate = self
        categoryScrollTabCollectionView.dataSource = self
        categoryScrollTabCollectionView.registerCustomCell(CategoryScrollTabViewCell.self)
        categoryScrollTabCollectionView.showsHorizontalScrollIndicator = false

        // MEMO: タブ内のスクロール移動を許可する場合はtrueにし、許可しない場合はfalseとする
        categoryScrollTabCollectionView.isScrollEnabled = true
    }

    // UICollectionViewの一番最初のセル表示位置に関する設定
    private func setInitialCategoryScrollTabPosition() {

        // 押下した場所のインデックス値を持っておくために、実際のタブ個数の2倍の値を設定する
        currentSelectIndex = self.categoryList.count * 2
        //print("初期表示時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
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

        // 下線用のViewに付与したAutoLayoutの幅に関する制約値を更新する
        let targetWidth = CategoryScrollTabViewCell.calculateCategoryUnderBarWidthBy(title: categoryTitle)
        selectedCatogoryUnderlineWidth.constant = targetWidth
        UIView.animate(withDuration: 0.36, animations: {
            self.view.layoutIfNeeded()
        })
    }

    // UIPageViewControllerを動かす方向を受け取ったインデックス値(indexPath.row)と現在のインデックス値(currentSelectIndex)を元に算出する
    // MEMO: 親(ArticleViewController)のUIPageViewCotrollerの更新はCategoryScrollTabDelegateのメソッドを経由して実行する
    private func getCategoryScrollContentsDirection(selectedIndex: Int) -> UIPageViewController.NavigationDirection {
        
        // 下記の条件を満たす場合は例外的に進む方向とする
        // 1. 引数で渡されたインデックス値:
        //   - selectedIndex が (targetCollectionViewCellMaxIndex - targetContentsMaxIndex) と等しい
        // 2. 現在のインデックス値:
        //   - currentSelectIndex が targetCollectionViewCellMaxIndex と等しい
        if selectedIndex == targetCollectionViewCellMaxIndex - targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMaxIndex {
            return UIPageViewController.NavigationDirection.forward
        }

        // 下記の条件を満たす場合は例外的に戻す方向とする
        // 1. 引数で渡されたインデックス値:
        //   - selectedIndex が (targetCollectionViewCellMinIndex + targetContentsMaxIndex) と等しい
        // 2. 現在のインデックス値:
        //   - currentSelectIndex が targetCollectionViewCellMinIndex と等しい
        if selectedIndex == targetCollectionViewCellMinIndex + targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMinIndex {
            return UIPageViewController.NavigationDirection.reverse
        }

        // (現在のインデックス値 - 引数で渡されたインデックス値)を元に方向を算出する
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

    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // MEMO: 無限スクロールの対象とする場合はタブ表示要素の4倍余分に要素を表示する
        return categoryList.count * 4
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryScrollTabViewCell.self, indexPath: indexPath)
        let targetIndex = indexPath.row % categoryList.count
        let isSelectedTab = (indexPath.row % categoryList.count == currentSelectIndex % categoryList.count)
        cell.setCategory(name: categoryList[targetIndex], isSelected: isSelectedTab)
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // UIPageViewControllerを動かす方向を選択したインデックス値(indexPath.row)と現在のインデックス値(currentSelectIndex)を元に算出する
        let targetDirection = getCategoryScrollContentsDirection(selectedIndex: indexPath.row)

        // 押下した場所のインデックス値を現在のインデックス値を格納している変数(currentSelectIndex)にセットする
        currentSelectIndex = indexPath.row
        //print("タブ押下時の中央インデックス値:", currentSelectIndex)
        
        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        // 算出した現在のインデックス値・動かす方向の値を元に、UIPageViewControllerで表示しているインデックスの画面へ遷移する
        self.delegate?.moveToCategoryScrollContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: true
        )

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
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

    // 配置したUICollectionViewをスクロールしている際に実行される処理
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

    // 配置したUICollectionViewをスクロールが止まった際に実行される処理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロールが停止した際に見えているセルのインデックス値を格納して、真ん中にあるものを取得する
        // 参考: https://stackoverflow.com/questions/18649920/uicollectionview-current-visible-cell-index

        var visibleIndexPathList: [IndexPath] = []
        for cell in categoryScrollTabCollectionView.visibleCells {
            if let visibleIndexPath = categoryScrollTabCollectionView.indexPath(for: cell) {
                visibleIndexPathList.append(visibleIndexPath)
                //print("現在画面内に見えているセルのインデックス値:", visibleIndexPath)
            }
        }
        let targetIndexPath = visibleIndexPathList[1]
        
        // ※この部分は厳密には不要ではあるがdelegeteで引き渡す必要があるので設定している
        let targetDirection = getCategoryScrollContentsDirection(selectedIndex: targetIndexPath.row)

        // 押下した場所のインデックス値を現在のインデックス値を格納している変数(currentSelectIndex)にセットする
        currentSelectIndex = targetIndexPath.row
        //print("スクロールが慣性で停止した時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        // 算出した現在のインデックス値・動かす方向の値を元に、UIPageViewControllerで表示しているインデックスの画面へ遷移する
        self.delegate?.moveToCategoryScrollContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: false
        )

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
    }
}
