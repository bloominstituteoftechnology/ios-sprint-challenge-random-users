//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    
    // MARK: - Properties and Outlets
    var randomUserController: RandomUserController?
    var randomUser: RandomUser? {
        didSet {
            updateViews()
        }
    }
    private let randomUserFetchQueue = OperationQueue()
    private var activeOps: [String: FetchLargeImageOp] = [:]
    private var largeImageCache: Cache<String, UIImage> = Cache()

    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - View Loading Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let randomUser = randomUser else { return }
        activeOps[randomUser.phone]?.cancel()
    }
    
    private func updateViews() {
        guard let randomUser = randomUser else { return }
        
        nameLabel.text = randomUser.name
        phoneLabel.text = randomUser.phone
        emailLabel.text = randomUser.email
        loadImage(for: randomUser)
    }
    
    private func loadImage(for randomUser: RandomUser) {
        if let image = largeImageCache.value(for: randomUser.phone) {
            randomImageView.image = image
        } else {
            let fetchLargeImageOp = FetchLargeImageOp(randomUser: randomUser)
            
            let cacheOp = BlockOperation {
                guard let image = fetchLargeImageOp.largeImage else { return }
                self.largeImageCache.cache(value: image, for: randomUser.phone)
            }
            
            let imageOp = BlockOperation {
                guard let image = fetchLargeImageOp.largeImage else { return }
                self.randomImageView.image = image
            }
            
            cacheOp.addDependency(fetchLargeImageOp)
            imageOp.addDependency(fetchLargeImageOp)
            
            randomUserFetchQueue.addOperations([fetchLargeImageOp, cacheOp], waitUntilFinished: false)
            OperationQueue.main.addOperation(imageOp)
            activeOps[randomUser.phone] = fetchLargeImageOp
        }
    }
}
