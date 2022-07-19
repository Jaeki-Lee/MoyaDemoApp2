//
//  PhotoRequest.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Foundation

struct PhotoRequest: ModelType {
    var tags = "landscape, portrait"
    var tagmode = "any"
    var format = "json"
    var nojsoncallback = "1"
}
