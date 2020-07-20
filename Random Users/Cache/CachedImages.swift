//
//  CachedImages.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class CachedImages {
    
    private var randomUserQueue = DispatchQueue(label: "com.LambdaSchool.RandomUser.ImageCacheQueue")
    private var thumbnails: [User: UIImage] = [:]
    private var images: [User: UIImage] = [:]
    
    subscript (userThumbnails: User) -> UIImage? {
        get{
            return randomUserQueue.sync {
                thumbnails[userThumbnails]
            }
        }
        
        set {
            randomUserQueue.async {
                self.images[userThumbnails] = newValue
            }
        }
    }
    
    
    subscript (userImages: User) -> UIImage? {
        get{
            return randomUserQueue.sync {
                images[userImages]
            }
        }
        set {
            randomUserQueue.sync {
                self.images[userImages] = newValue
            }
        }
    }
}
