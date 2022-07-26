//
//  MyAPI+Task.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Moya

extension MyAPI {
    func getTask() -> Task {
        switch self {
        case .getPhotos(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
}

extension Encodable {
    func toDictionary() -> [String: Any] {
      do {
        let jsonEncoder = JSONEncoder()
        let encodedData = try jsonEncoder.encode(self)
        
        let dictionaryData = try JSONSerialization.jsonObject(
          with: encodedData,
          options: .allowFragments
        ) as? [String: Any]
        return dictionaryData ?? [:]
      } catch {
        return [:]
      }
    }
}
