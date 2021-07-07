//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
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

    var randomUser: RandomUser?
    let randomUserFetchQueue = OperationQueue()
    
    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
}
