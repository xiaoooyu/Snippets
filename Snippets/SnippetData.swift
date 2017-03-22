//
//  SnippetData.swft.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import Foundation

struct SnippetData {
    
    let type: SnippetType
    
    init(snippetType: SnippetType) {
        type = snippetType
        print ("\(type.rawValue) snippet created")
        
        
        
    }
}
