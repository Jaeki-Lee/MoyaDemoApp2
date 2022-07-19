//
//  MyAPI+Path.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Foundation

extension MyAPI {
    func getPath() -> String {
        switch self {
        case .getPhotos:
            return "services/feeds/photos_public.gne"
        }
    }
}
