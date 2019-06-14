//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        loadImage()
    }


    private func loadImage() {
        guard let user = user,
        let imageURL = URL(string: user.picture.large ),
        let cache = largeImageCache else { return }
        
        var imageData: Data?

        let cacheID = user.email
        if let imageData = cache.value(for: cacheID) {
            userImageView.image = UIImage(data: imageData)
            print("Loaded image from cache")
        } else {

            let fetchImageOperation = FetchImageOperation(url: imageURL)

            let getImageDataOperation = BlockOperation {
                imageData = fetchImageOperation.imageData
            }

            let cacheImageOperation = BlockOperation {
                guard let data = imageData else { return }
                self.largeImageCache?.cache(value: data, for: cacheID)
                print("Cached image fetch")
            }

            let setImageOperation = BlockOperation {
                guard let imageURL = fetchImageOperation.imageURL else { return }
                if "\(imageURL)" == user.picture.large {
                    DispatchQueue.main.async {
                        guard let data = imageData else { return }
                        self.userImageView.image = UIImage(data: data)
                    }
                }
            }

            let thumbnailQueue = OperationQueue()
            getImageDataOperation.addDependency(fetchImageOperation)
            cacheImageOperation.addDependency(getImageDataOperation)
            setImageOperation.addDependency(getImageDataOperation)

            fetchDictionary[cacheID] = fetchImageOperation
            thumbnailQueue.addOperations([fetchImageOperation, getImageDataOperation, cacheImageOperation, setImageOperation], waitUntilFinished: false)
        }
    }

    func updateView() {
        guard let user = user else { return }

        DispatchQueue.main.async {
        self.nameLabel.text = "\(user.name.title.capitalizingFirstLetter()). \(user.name.first.capitalizingFirstLetter()) \(user.name.last.capitalizingFirstLetter())"
        self.phoneNumberLabel.text = user.phone
        self.emailLabel.text = user.email
        self.navigationItem.title = user.name.first.capitalizingFirstLetter() + " " + user.name.last.capitalizingFirstLetter()
        }
    }


    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var user: Result?
    var largeImageCache: Cache<String, Data>?
    var fetchDictionary: [String : FetchImageOperation] = [:]
    

}

