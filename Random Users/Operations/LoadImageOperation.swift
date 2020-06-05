//
//  LoadImageOperation.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class LoadImageOperation: ConcurrentOperation {

    //MARK: - Properties

    let url: URL
    let imageView: UIImageView
    let cache: Cache<URL, Data>

    //MARK: - Init

    init(url: URL, imageView: UIImageView, cache: Cache<URL, Data>) {
        self.url = url
        self.imageView = imageView
        self.cache = cache
    }

    //MARK: - Private

    private let loadImageQueue: OperationQueue = {
        let liq = OperationQueue()
        liq.name = "Load Image Queue"
        return liq
    }()

    private lazy var fetchOp = FetchImageOperation(imageURL: url)

    private lazy var cacheOp = BlockOperation {
        guard !self.isCancelled, let imageData =
            self.fetchOp.imageData else { return }
        let size = imageData.count
        self.cache.cache(imageData, ofSize: size, for: self.url)
    }

    private lazy var updateCellOp = BlockOperation {
        guard !self.isCancelled, let imageData =
            self.fetchOp.imageData,
            let image = UIImage(data: imageData) else { return }
        self.imageView.image = image
    }

    //MARK: - Overrides

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

        cacheOp.addDependency(fetchOp)
        updateCellOp.addDependency(fetchOp)

        OperationQueue.main.addOperation(updateCellOp)
        loadImageQueue.addOperations([fetchOp, cacheOp], waitUntilFinished: false)

        state = .isFinished
    }

    override func cancel() {
        fetchOp.cancel()
        cacheOp.cancel()
        updateCellOp.cancel()
    }
}
