//
//  HomeViewModel.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
import Combine

protocol HomeViewModelProtocol{
    var cancellables:Set<AnyCancellable> { get}
    var loading:Bool { get }
    var albums:[Albums] { get}
    var photos:[Photos] { get}
    
    func getUsers()
    func getAlbums(userId: Int)
}

class HomeViewModel: HomeViewModelProtocol {
    
    let networkService: NetworkManagerProtocol
    var cancellables = Set<AnyCancellable>()
    @Published private(set) var loading:Bool = false
    @Published private(set) var albums: [Albums] = []
    @Published private(set) var photos: [Photos] = []
   
    init(networkService: NetworkManagerProtocol) {
        self.networkService = networkService
    }
    
    func getUsers(){
        loading = true
        networkService.getData(endPoint: .user)
            .sink { completion in
                switch completion {
                case .finished:
                    print("request finished")
                case .failure(let error):
                    print("request user failed \(error.localizedDescription)")
                }
            } receiveValue: {[weak self] (users:[User]) in
                guard let user = users.randomElement() else {return}
                print(user)
                UserDefaults.standard.saveUser(user)
                self?.getAlbums(userId: user.id)
            }.store(in: &cancellables)

    }
    
    func getAlbums(userId: Int){
        loading = true
        networkService.getData(endPoint: .albums(userId: userId))
            .sink { completion in
                switch completion {
                case .finished:
                    print("request finished")
                case .failure(let error):
                    print("request albums failed \(error.localizedDescription)")
                }
            } receiveValue: {[weak self] (albums:[Albums]) in
                self?.loading = false
                self?.albums = albums
            }.store(in: &cancellables)
    }
    
    func getPhotos(albumId: Int) {
        networkService.getData(endPoint: .photos(albumId: albumId))
            .sink { completion in
                switch completion {
                case .finished:
                    print("request finished")
                case .failure(let error):
                    print("request photos failed \(error.localizedDescription)")
                }
            } receiveValue: {[weak self] (photos:[Photos]) in
                self?.loading = false
                self?.photos = photos
            }.store(in: &cancellables)
    }
}
