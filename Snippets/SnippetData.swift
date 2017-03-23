//
//  SnippetData.swft.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import Foundation
import UIKit

class SnippetData {
    
    let type: SnippetType
    
    init(snippetType: SnippetType) {
        type = snippetType
        print ("\(type.rawValue) snippet created")
    }
}

class PhotoData: SnippetData {
    let photoData: UIImage
    init(photo: UIImage) {
        photoData = photo
        super.init(snippetType: .photo)
        print("Photo snipper data: \(photoData)")
    }
}
