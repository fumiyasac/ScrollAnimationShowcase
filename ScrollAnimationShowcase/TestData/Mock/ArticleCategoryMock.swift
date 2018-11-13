//
//  ArticleCategoryMock.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/13.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct ArticleCategoryMock {

    // 記事カテゴリーデータを表示する
    static func getArticleCategory() -> [String] {
        return [
            "簡単節約TIPS",
            "暮らしのマネー",
            "経済ニュース",
            "お買い物情報",
            "時短レシピ紹介",
            "その他の情報",
        ]
    }
}
