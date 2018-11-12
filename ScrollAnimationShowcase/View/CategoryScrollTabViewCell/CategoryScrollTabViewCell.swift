//
//  CategoryScrollTabViewCell.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/10.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

final class CategoryScrollTabViewCell: UICollectionViewCell {

    // カテゴリー選択用セルのサイズ
    static let cellSize: CGSize = CGSize(
        width: AppConstant.CATEGORY_CELL_WIDTH,
        height: AppConstant.CATEGORY_CELL_HEIGHT
    )

    @IBOutlet weak private var categoryTitleLabel: UILabel!

    // MARK: - Class Function

    // カテゴリー表示用の下線の幅を算出する
    class func calculateCategoryUnderBarWidthBy(title: String) -> CGFloat {

        // テキストの属性を設定する
        var categoryTitleAttributes = [NSAttributedString.Key : Any]()
        categoryTitleAttributes[NSAttributedString.Key.font] = UIFont(
            name: AppConstant.CATEGORY_FONT_NAME,
            size: AppConstant.CATEGORY_FONT_SIZE
        )

        // 引数で渡された文字列とフォントから配置するラベルの幅を取得する
        let categoryTitleLabelSize = CGSize(
            width: .greatestFiniteMagnitude,
            height: AppConstant.CATEGORY_FONT_HEIGHT
        )
        let categoryTitleLabelRect = title.boundingRect(
            with: categoryTitleLabelSize,
            options: .usesLineFragmentOrigin,
            attributes: categoryTitleAttributes,
            context: nil)

        return ceil(categoryTitleLabelRect.width)
    }

    // MARK: - Function

    func setCategory(name: String) {
        categoryTitleLabel.text = name
    }
}
