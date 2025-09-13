//
//  Photo.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
struct Photos : Decodable {
  var albumId: Int
  var id: Int
  var title: String
  var url: String
  var thumbnailUrl: String
}
