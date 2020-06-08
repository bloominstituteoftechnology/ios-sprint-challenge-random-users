//
//  FetchLargePhotoOperation.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchLargePhoto {
    
    
    func downloadImage(widthURL url: URL, completion: @escaping (_ image: UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        
        dataTask.resume()
    }
    
}
