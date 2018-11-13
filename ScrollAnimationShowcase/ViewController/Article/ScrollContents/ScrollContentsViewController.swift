//
//  ScrollContentsViewController.swift
//  ScrollAnimationShowcase
//
//  Created by 酒井文也 on 2018/11/13.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class ScrollContentsViewController: UIViewController {

    // MEMO: 後に実際のものに差し替える

    @IBOutlet weak private var sampleTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function

    func setTitle(text: String) {
        sampleTitleLabel.text = "現在表示しているIndex値：\(text)"
    }
}
