//
//  LoadImageOperation.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class LoadImageOperation: ConcurrentOperation {
    let url: URL
    var image: UIImage?
    var data: Data?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        if let data = try? Data(contentsOf: url) {
            self.data = data
            if let image = UIImage(data: data) {
                self.image = image
            }
        }
        state = .isFinished
    }
}
