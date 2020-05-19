//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - Properties
    
    var user: User? {
          didSet {
              updateViews()
          }
      }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Functions
    
    private func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        nameLabel.text = "\(user.name.title). \(user.name.first) \(user.name.last)"
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        if let image = Cache.cache[user] {
            imageView.image = image
        } else {
            let imageFetch = ImageOperations(user: user, imageType: .fullsize)
            let update = BlockOperation {
                guard user == self.user else { return }
                self.imageView.image = imageFetch.result
            }
            update.addDependency(imageFetch)
            OperationQueue.main.addOperations([imageFetch, update], waitUntilFinished: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
}
