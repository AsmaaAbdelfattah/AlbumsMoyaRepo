//
//  AlbumTBCell.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import UIKit

class AlbumTBCell: UITableViewCell {

    @IBOutlet weak var albumName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
