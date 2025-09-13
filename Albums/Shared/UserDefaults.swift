//
//  UserDefaults.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
enum UserDefaultsKey: String{
    case token
    case baseUrl
}
extension UserDefaults{
    func setToken(value: String){
        setValue(value, forKey: UserDefaultsKey.token.rawValue)
    }
    func getToken() -> String{
        return string(forKey: UserDefaultsKey.token.rawValue) ?? ""
    }

    func setBase(value: String){
        setValue(value, forKey: UserDefaultsKey.baseUrl.rawValue)
    }
    func getBase() -> String{
        return string(forKey: UserDefaultsKey.baseUrl.rawValue) ?? "en"
    }
    func saveUser(_ user:  User) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedData, forKey: "user")
        }
    }

    // Retrieve custom object from UserDefaults
    func getUser() -> User? {
        if let savedData = UserDefaults.standard.data(forKey: "user") {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: savedData) {
                return user
            }
        }
        return nil
    }
}
