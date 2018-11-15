//
//  ArticleViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/10.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    // カテゴリーの一覧データ
    private let categoryList: [String] = ArticleCategoryMock.getArticleCategory()

    // 現在表示しているViewControllerのタグ番号
    private var currentCategoryIndex: Int = 0
    
    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController?

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
    }

    // Segueに設定したIdentifierから接続されたViewControllerを取得する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {

        // ContainerViewで接続されたViewController側に定義したプロトコルを適用する
        case "CategoryScrollTabViewContainer":
            let vc = segue.destination as! CategoryScrollTabViewController
            vc.delegate = self

        default:
            break
        }
    }

    // MARK: - Private Function

    private func setupPageViewController() {

        // UIPageViewControllerで表示させるViewControllerの一覧を配列へ格納する
        let _ = categoryList.enumerated().map{ (index, categoryName) in
            let sb = UIStoryboard(name: "Article", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "CategoryScrollContents") as! CategoryScrollContentsViewController
            vc.view.tag = index
            vc.setTitle(text: categoryName)
            targetViewControllerLists.append(vc)
        }

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        for childVC in children {
            if let targetVC = childVC as? UIPageViewController {
                pageViewController = targetVC
            }
        }
        
        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        
        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }

    // 配置されているタブ表示のUICollectionViewの位置を更新する
    // MEMO: ContainerViewで配置しているViewControllerの親子関係を利用する
    private func updateCategoryScrollTabPosition(isIncrement: Bool) {
        for childVC in children {
            if let targetVC = childVC as? CategoryScrollTabViewController {
                targetVC.moveToCategoryScrollTab(isIncrement: isIncrement)
            }
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension ArticleViewController: UIPageViewControllerDelegate {
    
    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                // Case1: UIPageViewControllerで表示する画面のインデックス値が左スワイプで 0 → 最大インデックス値
                if targetViewController.view.tag - currentCategoryIndex == -categoryList.count + 1 {
                    updateCategoryScrollTabPosition(isIncrement: true)

                // Case2: UIPageViewControllerで表示する画面のインデックス値が右スワイプで 最大インデックス値 → 0
                } else if targetViewController.view.tag - currentCategoryIndex == categoryList.count - 1 {
                    updateCategoryScrollTabPosition(isIncrement: false)

                // Case3: UIPageViewControllerで表示する画面のインデックス値が +1
                } else if targetViewController.view.tag - currentCategoryIndex > 0 {
                    updateCategoryScrollTabPosition(isIncrement: true)

                // Case4: UIPageViewControllerで表示する画面のインデックス値が -1
                } else if targetViewController.view.tag - currentCategoryIndex < 0 {
                    updateCategoryScrollTabPosition(isIncrement: false)
                }

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                currentCategoryIndex = targetViewController.view.tag
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ArticleViewController: UIPageViewControllerDataSource {

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return targetViewControllerLists.last
        } else {
            return targetViewControllerLists[index - 1]
        }
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return targetViewControllerLists.first
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}

// MARK: - CategoryScrollTabDelegate

extension ArticleViewController: CategoryScrollTabDelegate {

    // タブ側のViewControllerで選択されたインデックス値とスクロール方向を元に表示する位置を調整する
    func moveToCategoryScrollContents(selectedCollectionViewIndex: Int, targetDirection: UIPageViewController.NavigationDirection, withAnimated: Bool) {

        // UIPageViewControllerに設定した画面の表示対象インデックス値を設定する
        // MEMO: タブ表示のUICollectionViewCellのインデックス値をカテゴリーの個数で割った剰余
        currentCategoryIndex = selectedCollectionViewIndex % categoryList.count

        // 表示対象インデックス値に該当する画面を表示する
        pageViewController!.setViewControllers([targetViewControllerLists[currentCategoryIndex]], direction: targetDirection, animated: withAnimated, completion: nil)
    }
}
