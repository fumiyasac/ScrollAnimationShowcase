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

        setupNavigationBarTitle("サンプル記事詳細")
        setupContentsScrollView()
        setupContentsDetailHeaderView()
    }

    // MARK: - @IBActions

    @IBAction func openSampleCodeLink(_ sender: Any) {
        if let url = URL(string: "https://github.com/fumiyasac/ScrollAnimationShowcase") {
            UIApplication.shared.open(url, options: [:])
        }
    }
 
    @IBAction func openDigitalBookLink(_ sender: Any) {
        if let url = URL(string: "https://booth.pm/ja/items/1021745") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Private Function

    private func setupContentsDetailHeaderView() {
        contentsDetailHeaderView.setHeaderImage(UIImage.init(named: "sample"))
    }

    private func setupContentsScrollView() {

        // NavigationBar分のスクロール位置がずれてしまうのでその考慮を行う
        if #available(iOS 11.0, *) {
            contentsScrollView.contentInsetAdjustmentBehavior = .never
        }
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
