//
//  MyAPI+BaseURL.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Foundation

extension MyAPI {
    func getBaseURL() -> URL {
        return URL(string: "https://api.flickr.com/")!
    }
}
