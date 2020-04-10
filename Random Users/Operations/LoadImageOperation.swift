//
//  LoadImageOperation.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class LoadImageOperation: ConcurrentOperation {
    // MARK: - Properties
    
    let url: URL
    let imageView: UIImageView
    let cache: Cache<URL, Data>
    
    // MARK: - Init
    
    init(url: URL, imageView: UIImageView, cache: Cache<URL, Data>) {
        self.url = url
        self.imageView = imageView
        self.cache = cache
    }
    
    // MARK: - Private
    
    private let loadImageQueue: OperationQueue = {
        let liq = OperationQueue()
        liq.name = "Load Image Queue"
        return liq
    }()
    
    private lazy var fetchOperation = FetchImageOperation(imageURL: url)
    
    override func start() {
        state = .isExecuting
        
        let cachedData = cache.value(for: url)
        if let cachedData = cachedData, let image = UIImage(data: cachedData) {
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            state = .isFinished
            return
        }

        let cacheOperation = BlockOperation {
            guard let imageData = self.fetchOperation.imageData else { return }
            let size = imageData.count
            self.cache.cache(imageData, ofSize: size, for: self.url)
        }
        
        cacheOperation.addDependency(fetchOperation)
        
        let updateCellOperation = BlockOperation {
            guard let imageData = self.fetchOperation.imageData,
                let image = UIImage(data: imageData) else { return }
            self.imageView.image = image
        }
        
        updateCellOperation.addDependency(fetchOperation)
        
        OperationQueue.main.addOperation(updateCellOperation)
        loadImageQueue.addOperations([fetchOperation, cacheOperation], waitUntilFinished: false)
        
        state = .isFinished
    }
    
    override func cancel() {
        fetchOperation.cancel()
    }
    
}
