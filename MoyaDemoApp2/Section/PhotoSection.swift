//
//  PhotoSection.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import RxDataSources

//RxDataSources에 사용하기 위해 SectionModel 정의

enum PhotoSectionItem: Equatable {
    case result(Photo.Item)
}

enum PhotoSection {
    case result([PhotoSectionItem])
}

extension PhotoSection: SectionModelType {
    var items: [PhotoSectionItem] {
      switch self {
      case .result(let photos): return photos
      }
    }
    
    init(original: PhotoSection, items: [PhotoSectionItem]) {
      switch original {
      case .result: self = .result(items)
      }
    }
}

extension PhotoSection: Equatable {
  static func == (lhs: PhotoSection, rhs: PhotoSection) -> Bool {
    lhs.items == rhs.items
  }
}


