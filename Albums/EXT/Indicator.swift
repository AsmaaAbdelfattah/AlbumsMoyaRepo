//
//  Indicator.swift
//  Albums
//
//  Created by asma abdelfattah on 13/09/2025.
//

import Foundation
import NVActivityIndicatorView

extension NVActivityIndicatorView{
    public func showIndicator(start:Bool){
        self.isHidden = !start
        if start{
            self.type = .ballSpinFadeLoader
            self.color = .blue
            self.startAnimating()
        }else{
            self.stopAnimating()
        }
    }
}

