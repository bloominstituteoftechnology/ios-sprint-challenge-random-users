//
//  ShadowView.swift
//  Random Users
//
//  Created by Fabiola S on 11/11/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit


class ShadowView: UIView {
    
    override func awakeFromNib() {
        layer.shadowPath = CGPath(rect: layer.bounds, transform:  nil)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        
        layer.cornerRadius = 5
    }
}
