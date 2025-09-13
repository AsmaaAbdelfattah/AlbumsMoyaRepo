//
//  ViewController.swift
//  Albums
//
//  Created by asma abdelfattah on 12/09/2025.
//

import UIKit
import Combine
import NVActivityIndicatorView

class HomeVC: UIViewController {
    //MARK: Outltes
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userAlbumsTB: UITableView!{
        didSet{
            userAlbumsTB.register(UINib(nibName: "AlbumTBCell", bundle: nil), forCellReuseIdentifier: "AlbumTBCell")
            userAlbumsTB.rowHeight = 45
            userAlbumsTB.dataSource = self
            userAlbumsTB.delegate = self
        }
    }
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
   
    //MARK: Vars
    let viewModel = HomeViewModel(networkService: NetworkManager.networkManager)
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        handleResponse()
    }
    
    //MARK: intial Screen
    func initView(){
        guard let user = UserDefaults.standard.getUser() else {
            viewModel.getUsers()
            return
        }
        indicator.showIndicator(start: true)
        viewModel.getAlbums(userId: user.id)
        bindUser(user)
    }

    //MARK: bind user data
    func bindUser(_ user:User){
        userName.text = user.name
        userAddress.text = user.address.street + " , " + user.address.suite + " , " + user.address.city + " , " + user.address.zipcode
    }


    //MARK: handle response
    func handleResponse(){
     
        viewModel.$loading.sink { [weak self]loading in
            self?.indicator.showIndicator(start: loading)
        }.store(in: &cancellables)
      
        viewModel.$albums.receive(on: RunLoop.main)
            .sink { [weak self] albums in
                if albums.count > 0 {
                    self?.bindUser(UserDefaults.standard.getUser()!)
                    self?.userAlbumsTB.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: Binding albums in TB
extension HomeVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTBCell", for: indexPath) as? AlbumTBCell else {return UITableViewCell()}
        cell.injectCell(album: viewModel.albums[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AlbumDetails", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "albumDetails") as? AlbumDetailsVC {
            vc.id = viewModel.albums[indexPath.row].id
            vc.navigationItem.title = viewModel.albums[indexPath.row].title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
