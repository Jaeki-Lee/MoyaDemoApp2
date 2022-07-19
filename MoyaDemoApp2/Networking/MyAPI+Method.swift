//
//  MyAPI+Method.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Foundation
import Moya

extension MyAPI {
    func getMethod() -> Moya.Method {
        switch self {
        case .getPhotos:
            return .get
        }
    }
}
