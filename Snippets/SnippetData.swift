//
//  SnippetData.swft.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SnippetData {
    
    let type: SnippetType
    let date: Date
    let coordinate: CLLocationCoordinate2D?
    
    init(snippetType: SnippetType, creationDate: Date,
        creationCoordinate: CLLocationCoordinate2D) {
        type = snippetType
        date = creationDate
        coordinate = creationCoordinate
        print ("\(type.rawValue) snippet created on \(date) at \(coordinate.debugDescription)")
    }
}

class TextData: SnippetData {
    let textData: String
    
    init(text: String, creationDate: Date,
         creationCoordinate: CLLocationCoordinate2D) {
        textData = text;
        super.init(snippetType: .text, creationDate: creationDate, creationCoordinate: creationCoordinate)
        print ("Text snippet data: \(textData)")
    }
}

class PhotoData: SnippetData {
    let photoData: UIImage
    init(photo: UIImage, creationDate: Date,
         creationCoordinate: CLLocationCoordinate2D) {
        photoData = photo
        super.init(snippetType: .photo, creationDate: creationDate, creationCoordinate: creationCoordinate)
        print("Photo snipper data: \(photoData)")
    }
}
