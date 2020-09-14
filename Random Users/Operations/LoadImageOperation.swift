//
//  LoadImageOperation.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class LoadImageOperation: ConcurrentOperation {
    
    static let loadImageQueue: OperationQueue = {
        let liq = OperationQueue()
        liq.name = "Load Image Queue"
        return liq
    }()
    
    // MARK: - Properties
    
    let url: URL
    let imageView: UIImageView
    let cache: Cache<URL, Data>
    
    // MARK: - Init
    
    init(url: URL, imageView: UIImageView, cache: Cache<URL, Data>) {
        self.url = url
        self.imageView = imageView
        self.cache = cache
        super.init()
        LoadImageOperation.loadImageQueue.addOperation(self)
    }
    
    // MARK: - Private
    
    private var shouldContinue = true
    
    private lazy var fetchOperation = FetchImageOperation(imageURL: url)
    
    private lazy var  cacheOperation = BlockOperation {
        guard self.shouldContinue, let imageData = self.fetchOperation.imageData else { return }
        let size = imageData.count
        self.cache.cache(imageData, ofSize: size, for: self.url)
    }
    
    private lazy var updateCellOperation = BlockOperation {
        guard self.shouldContinue, let imageData = self.fetchOperation.imageData,
            let image = UIImage(data: imageData) else { return }
        self.imageView.image = image
    }
    
    override func start() {
        state = .isExecuting
        
        // Check for cached data
        let cachedData = cache.value(for: url)
        if let cachedData = cachedData, let image = UIImage(data: cachedData) {
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            state = .isFinished
            return
        }

        cacheOperation.addDependency(fetchOperation)
        updateCellOperation.addDependency(fetchOperation)
        
        OperationQueue.current?.addOperations([fetchOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperations([updateCellOperation], waitUntilFinished: true)
        
        self.state = .isFinished
    }
    
    override func cancel() {
        fetchOperation.cancel()
        shouldContinue = false
    }
    
}
