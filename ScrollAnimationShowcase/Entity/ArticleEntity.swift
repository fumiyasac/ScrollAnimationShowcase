//
//  ArticleEntity.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/25.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct ArticleEntity {

    // メンバ変数
    let id: Int
    let title: String
    let catchcopy: String
    let category: String
    let imageFile: UIImage?

    // イニシャライザ
    init(id: Int, title: String, catchcopy: String, category: String, imageFileName: String) {
        self.id        = id
        self.title     = title
        self.catchcopy = catchcopy
        self.category  = category
        self.imageFile = UIImage(named: imageFileName)
    }
}
