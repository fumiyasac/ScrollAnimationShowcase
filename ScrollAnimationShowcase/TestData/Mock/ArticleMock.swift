//
//  ArticleCategoryMock.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/13.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct ArticleMock {

    private static let titleSamples: [String] = [
        "安いけど美味しい自炊",
        "まずは収入と支出から",
        "前に攻める貯金ライフ",
    ]
    
    private static let catchcopySamples: [String] = [
        "食生活から無駄を排除!",
        "家計簿は生活の基準値!",
        "安心と今後の為の貯金!",
    ]

    private static let dateStringSamples: [String] = [
        "2018.10.08",
        "2018.11.25",
        "2018.08.04",
    ]

    private static let categories: [String] = [
        "簡単節約TIPS",
        "暮らしのマネー",
        "経済ニュース",
        "お買い物情報",
        "時短レシピ紹介",
        "その他の情報",
    ]

    // 記事カテゴリーデータを表示する
    static func getArticleCategories() -> [String] {
        return categories
    }

    // 18個分のサンプルデータを作成する(引数にカテゴリーIDを渡す)
    static func getArticlesBy(categoryId: Int) -> [ArticleEntity] {

        var articles: [ArticleEntity] = []

        for i in 1...18 {
            let randomIndex = Int.createRandom(range: Range(0...2))
            articles.append(
                ArticleEntity.init(
                    id: i,
                    title: titleSamples[randomIndex],
                    catchcopy: catchcopySamples[randomIndex],
                    category: categories[categoryId],
                    imageFileName: "thumb\(randomIndex + 1)",
                    dateString: dateStringSamples[randomIndex]
                )
            )
        }
        return articles
    }
}
