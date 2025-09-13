//
//  NetworkManager.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
import Moya
import CombineMoya
import Combine
protocol NetworkManagerProtocol {
    var provider:MoyaProvider<Networking>  {get}
  
    func getData<T:Decodable>(endPoint: Networking) -> AnyPublisher<[T], Error>
}
class NetworkManager :NetworkManagerProtocol{
  
    static let networkManager = NetworkManager()
    var provider = MoyaProvider<Networking>(plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    private init(){
        
    }
    
    func getData<T:Decodable>(endPoint: Networking) -> AnyPublisher<[T], Error> {
        provider.requestPublisher(endPoint)
            .handleEvents(receiveOutput: { response in
                           // 🔍 Print URL + Headers + Status Code manually if needed
                           if let request = response.request {
                               print("➡️ Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
                               print("Headers: \(request.allHTTPHeaderFields ?? [:])")
                           }
                           print("⬅️ Status Code: \(response.statusCode)")
                           
                           if let jsonString = String(data: response.data, encoding: .utf8) {
                               print("Response JSON: \(jsonString)")
                           }
                       })
            .retry(2)
            .tryMap { response -> [T] in
                do {
                     let data = try JSONDecoder().decode([T].self, from: response.data)
                      return data
                   } catch {
                     throw error
                   }
            }.eraseToAnyPublisher()
    }
}
