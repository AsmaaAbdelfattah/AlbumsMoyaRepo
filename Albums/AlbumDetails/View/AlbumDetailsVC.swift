//
//  AlbumDetailsVC.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import UIKit
import NVActivityIndicatorView
import Combine
import SKPhotoBrowser
class AlbumDetailsVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            searchBar.placeholder = "Search in images..."
        }
    }
    @IBOutlet weak var photosCV: UICollectionView!{
        didSet{
            photosCV.register(UINib(nibName: "PhotosCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCVCell")
            photosCV.delegate = self
            photosCV.dataSource = self
        }
    }
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    //MARK: var
    var id: Int?
    var viewModel = HomeViewModel(networkService: NetworkManager.networkManager)
    var cancellables = Set<AnyCancellable>()
    var photos:[Photos] = []
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ID = id{
            indicator.showIndicator(start: true)
            viewModel.getPhotos(albumId: ID)
        }
        handleResponse()
    }
    
    //MARK: handle response
    func handleResponse(){
        viewModel.$loading.sink { [weak self]loading in
            self?.indicator.showIndicator(start: loading)
        }.store(in: &cancellables)
        viewModel.$photos.receive(on: RunLoop.main)
            .sink { [weak self] photos in
                self?.photos = photos
                self?.photosCV.reloadData()
            }
            .store(in: &cancellables)
    }
}
//MARK: photos binding CV
extension AlbumDetailsVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCVCell", for: indexPath) as? PhotosCVCell else{return UICollectionViewCell()}
        cell.injectCell(photo: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //MARK: open image with zooming
        let photo = SKPhoto.photoWithImageURL( viewModel.photos[indexPath.row].url,holder: UIImage(named: "placeholder"))
        // Create and Present the Photo Browser
        SKPhotoBrowserOptions.displayAction = true
        let browser = SKPhotoBrowser(photos:[photo])
        browser.initializePageIndex(0) // Start at the first image
        browser.delegate = self
        present(browser, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.width * 0.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
//MARK: handle search
extension AlbumDetailsVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            photos = viewModel.photos
        }else{
            photos = viewModel.photos.filter { $0.title.lowercased().contains(searchText.lowercased())}
        }
        
        photosCV.reloadData()
    }
    
}
//MARK: handle share
extension AlbumDetailsVC: SKPhotoBrowserDelegate {
    private func didShowActionSheet(_ browser: SKPhotoBrowser) {
        guard let image = browser.photos[browser.currentPageIndex].underlyingImage else { return }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
