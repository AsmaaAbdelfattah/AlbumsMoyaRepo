//
//  Useer.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
struct User: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}
struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: GEO
}
struct GEO: Codable {
    var lat: String
    var lng: String
}
struct Company: Codable {
    var name: String
    var catchPhrase: String
    var bs: String
}
