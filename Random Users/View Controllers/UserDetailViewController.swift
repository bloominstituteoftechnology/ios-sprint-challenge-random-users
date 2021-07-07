//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else { return }
        let op1 = FetchImageOperation(user: user, imageType: .large)
        let op2 = BlockOperation {
            guard let image = op1.image else { return }
            self.imageView.image = image
        }
        op2.addDependency(op1)
        
        userFetchQueue.addOperation(op1)
        OperationQueue.main.addOperation(op2)
        
        nameLabel.text = user.name
        phoneNumberLabel.text = user.phoneNumber
        emailAddressLabel.text = user.emailAddress
    }
    
    // MARK: - Properties
    
    var user: User?
    // should I make a new instance or pass the tableView's over??
    let userFetchQueue = OperationQueue()
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
}
