//
//  UserManager.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserManager {
    
    var addressbook: [User] = []
    
    var thumbnails: [UIImage] = []
    
    var fullsizes: [UIImage] = []
    
    
    func loadImages(path: IndexPath){
        
    let thumbRef = addressbook[path.row].picture.thumbnail
    let fullRef = addressbook[path.row].picture.large
        
    guard let thumbURL = URL(string: thumbRef) else { return }
    guard let fullURL = URL(string: fullRef) else { return }
        
    let thumbData = try? Data(contentsOf: thumbURL) //Pull image Data from URL
    let fullData = try? Data(contentsOf: fullURL)

    
    if let thumbImageData = thumbData { //Unwrap image data
        let thumbImage = UIImage(data: thumbImageData) //Create image from data
        thumbnails.append(thumbImage!)
    }
      
    if let fullImageData = fullData {
        let fullImage = UIImage(data: fullImageData)
        fullsizes.append(fullImage!)
        }
        
    }//End of Load Images Function
}
