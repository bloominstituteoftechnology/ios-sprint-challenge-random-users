//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure we have a user
        guard let user = user else { return }
        
        // Get and display the large image
       // displayUserImage(user.largeImageURL!)
        let fetchLargeImage = LargeImageFetch(randomUser: user)
        let blockOperation = BlockOperation {
            guard let largeImage = fetchLargeImage.largeImage else { return }
            self.userImageView.image = largeImage
        }
        blockOperation.addDependency(fetchLargeImage)
        fetchRandomUserQueue.addOperation(blockOperation)
        OperationQueue.main.addOperation(blockOperation)
        
        // Display the text data
         populateLabels(user)
    }
    
    
    // MARK: - Display user details
    func displayUserImage(_ imageURL: URL) {
        let fetchLargeImage = LargeImageFetch(randomUser: user!)
        let blockOperation = BlockOperation {
            guard let largeImage = fetchLargeImage.largeImage else { return }
            self.userImageView.image = largeImage
        }
        blockOperation.addDependency(fetchLargeImage)
        fetchRandomUserQueue.addOperation(blockOperation)
        OperationQueue.main.addOperation(blockOperation)
    }
    
    // Display the user name, phone, and email
    func populateLabels(_ user: RandomUser) {
        userNameLabel.text = user.name
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
    }
    
    
    // MARK: - Properties
    var user: RandomUser?
    let fetchRandomUserQueue = OperationQueue()
    
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}
