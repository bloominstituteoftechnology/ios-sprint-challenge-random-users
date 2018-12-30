//
//  Cache.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 12/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class Cache {

    var imageCache = NSCache<NSString, UIImage>()


    func loadImages(url: URL, completion: @escaping (UIImage?) -> Void) {
    
    //First attempt to Load the Image from the Cache.
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) { completion(cachedImage) } else {

    //If Cached Image is not available, download it directly.
    let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)

    URLSession.shared.dataTask(with: request) { data, response, error in
            
            //Step 1 - Unwrap the error
            
        guard error == nil, data != nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            //Step 2 - Unwrap the data
            
            guard let photoData = data else { NSLog("Error: \(error?.localizedDescription))"); return }
            
            //Step 3 - Create the image using the data
        
            guard let image = UIImage(data: photoData) else { return }
        
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
            DispatchQueue.main.async { completion(image) }
            
            } .resume() //End of Data Task
        }//End of If Let Else
        
    }//End of Function
    
}//End of Class
