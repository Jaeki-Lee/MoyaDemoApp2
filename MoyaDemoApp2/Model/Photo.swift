//
//  Photo.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Foundation

struct Photo: ModelType {
  let title: String
  let link: String
  let items: [Item]
  
  struct Item: ModelType {
    let title: String
    let link: String
    let media: Media
    let author: String
    let authorID: String
    
    enum CodingKeys: String, CodingKey {
      case title
      case link
      case media
      case author
      case authorID = "author_id"
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
      lhs.link == rhs.link
    }
    
    struct Media: Codable {
      let urlString: String
      
      enum CodingKeys: String, CodingKey {
        case urlString = "m"
      }
    }
  }
  
  static func == (lhs: Photo, rhs: Photo) -> Bool {
    lhs.link == rhs.link
  }
}

