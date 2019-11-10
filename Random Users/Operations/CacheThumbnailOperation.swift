//
//  CacheThumbnail.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class ChacheThumbnailOperation: ConcurrentOperation {
    var loadOp: LoadImageOperation
    
    init(getImageFrom: LoadImageOperation, for url: URL) {
        self.loadOp = getImageFrom
        super.init()
    }
    
    override func main() {
        guard let data = loadOp.data else {
            state = .isFinished
            return
        }
        ImageCache.shared.cache(value: data, for: loadOp.url)
        state = .isFinished
    }
}
