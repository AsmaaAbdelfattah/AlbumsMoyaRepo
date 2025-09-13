//
//  API.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
import Moya
enum Networking{
 
    case user
    case albums(userId:Int)
    case photos(albumId:Int)
}
extension Networking:TargetType{
   
    var baseURL: URL {
        guard let URL = URL(string: UserDefaults.standard.getBase()) else {return URL(string: "")!}
        return URL
    }
    
    var path: String {
        switch self {
        case .user:
         return   "/users"
        case .albums:
            return "/albums"
        case .photos:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .user , .albums ,.photos:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .user:
            return .requestPlain
        case .albums(let userId):
            return .requestParameters(parameters: ["userId" : userId], encoding: URLEncoding.default)
        case .photos(let albumId):
            return .requestParameters(parameters: ["albumId" : albumId], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type":"application/json; charset=UTF-8"]
    }
    

 
}
