//
//  TextSnippetCell.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/24/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import Foundation
import UIKit

class TextSnippetCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var date: UILabel!
    var shareButton: (() -> Void)?
    
    @IBAction func shareButtonPressed() {
        if let callback = shareButton {
            callback()
        }
    }
}
