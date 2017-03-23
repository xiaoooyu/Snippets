//
//  TextSnippet.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/22/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import Foundation

class TextData: SnippetData {
    let textData: String
    
    init(text: String) {
        textData = text;
        super.init(snippetType: .text)
        print ("Text snippet data: \(textData)")
    }
}
