//
//  ContentsViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/09.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {

    @IBOutlet weak private var contentsScrollView: UIScrollView!
    @IBOutlet weak private var contentsDetailHeaderView: ContentsDetailHeaderView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("サンプル記事詳細: サンプルを見て頂きありがとうございます!")
        setupNavigationBarInitialState()
        setupContentsScrollView()
        setupContentsDetailHeaderView()
    }
    
    // MARK: - Private Function

    private func setupNavigationBarInitialState() {

    }

    private func setupContentsDetailHeaderView() {
        contentsDetailHeaderView.setHeaderImage(UIImage.init(named: "sample"))
    }

    private func setupContentsScrollView() {
        contentsScrollView.delegate = self
    }
}

// MARK: - UIScrollViewDelegate

extension ContentsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 画像のパララックス効果付きのViewに付与されているAutoLayout制約を変更してパララックス効果を出す
        contentsDetailHeaderView.setParallaxEffectToHeaderView(scrollView)
    }
}
