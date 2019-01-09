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

   static let imageCache = NSCache<NSString, UIImage>()

    static func loadImages(url: URL, completion: @escaping (_ peepimage: UIImage?) -> ()) {
    
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
        
        //Unwrap the image data
        var downloadedImage: UIImage?
 
        if let foundData = data { downloadedImage = UIImage(data: foundData) }
            
        //Save data to cache
        if downloadedImage != nil { imageCache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)}
 
        DispatchQueue.main.async {
            completion(downloadedImage) } //End of Dispatch Queue
            
        }//End of Data Task
    
        dataTask.resume()
        
    }//End of Function
    
    static func checkImage(url: URL, completion: @escaping (_ cacheimage: UIImage?) ->()) {
        if let cacheimage = imageCache.object(forKey: url.absoluteString as NSString) { completion(cacheimage) }
        else { loadImages(url: url, completion: completion)}
    }//End of Check Image function
}
