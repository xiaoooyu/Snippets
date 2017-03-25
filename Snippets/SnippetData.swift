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
    let date: Date
    
    init(snippetType: SnippetType, creationDate: Date) {
        type = snippetType
        date = creationDate
        print ("\(type.rawValue) snippet created as \(date)")
    }
}

class TextData: SnippetData {
    let textData: String
    
    init(text: String, creationDate: Date) {
        textData = text;
        super.init(snippetType: .text, creationDate: creationDate)
        print ("Text snippet data: \(textData)")
    }
}

class PhotoData: SnippetData {
    let photoData: UIImage
    init(photo: UIImage, creationDate: Date) {
        photoData = photo
        super.init(snippetType: .photo, creationDate: creationDate)
        print("Photo snipper data: \(photoData)")
    }
}
