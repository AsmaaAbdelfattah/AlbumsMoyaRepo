//
//  ViewController.swift
//  Albums
//
//  Created by asma abdelfattah on 12/09/2025.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userAlbumsTB: UITableView!{
        didSet{
            userAlbumsTB.register(UINib(nibName: "AlbumTBCell", bundle: nil), forCellReuseIdentifier: "AlbumTBCell")
            userAlbumsTB.rowHeight = 60
            userAlbumsTB.dataSource = self
            userAlbumsTB.delegate = self
        }
    }
  
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

//MARK: Binding albums in TB
extension HomeVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTBCell", for: indexPath) as? AlbumTBCell else {return UITableViewCell()}
        return cell
    }
}
