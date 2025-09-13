//
//  PhotosCVCell.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import UIKit

class PhotosCVCell: UICollectionViewCell {

    @IBOutlet weak var photoImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func injectCell(photo: Photos){
        photoImg.setPlaceHolder(img: photo.url)
    }
}
