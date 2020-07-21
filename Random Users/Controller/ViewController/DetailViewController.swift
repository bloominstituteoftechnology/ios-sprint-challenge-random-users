//
//  DetailViewController.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        nameLabel.text = "\(user.name)"
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        if let image = CachedImages.shared[user] {
            imageView.image = image
        } else {
            let fetchImage = ImageFetch(userImage: user, imageSize: .fullsize)
            let updateViewsOperation = BlockOperation {
                guard user == self.user else { return }
                self.imageView.image = fetchImage.imageResults
            }
            updateViewsOperation.addDependency(fetchImage)
            OperationQueue.main.addOperations([fetchImage, updateViewsOperation], waitUntilFinished: false)
        }
    }
}
