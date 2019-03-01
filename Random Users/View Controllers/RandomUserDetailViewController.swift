//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Paul Yi on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let randomUser = randomUser else { return }
        let largeImageOperation = FetchLargeImageOperation(randomUser: randomUser)
        let operation = BlockOperation {
            guard let image = largeImageOperation.largeImage else { return }
            self.randomImageView.image = image
        }
        operation.addDependency(largeImageOperation)
        
        randomUserFetchQueue.addOperation(largeImageOperation)
        OperationQueue.main.addOperation(operation)
        
        nameLabel.text = randomUser.name
        phoneNumberLabel.text = randomUser.phoneNumber
        emailAddressLabel.text = randomUser.emailAddress
    }
    
    // MARK: - Properties
    
    var randomUser: RandomUser?
    let randomUserFetchQueue = OperationQueue()
    
    // MARK: - Outlets
    
    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
}
