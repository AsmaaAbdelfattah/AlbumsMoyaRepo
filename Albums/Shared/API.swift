//
//  API.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
enum Networking{
    private var baseURL: String { return  UserDefaults.standard.getBase()}
  
    case user
    case albums
    case photos
}
extension Networking{

    var fullPath :String {
        var endPoint: String
        switch self {
            
            //MARK: user
        case .user:
            endPoint = "/users"
         
            //MARK: images
        case .albums:
            endPoint = "/albums"
        case .photos:
            endPoint = "/photos"
        }
        return baseURL + endPoint
    }
}
