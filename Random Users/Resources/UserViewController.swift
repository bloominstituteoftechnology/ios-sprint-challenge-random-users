//
//  UserViewController.swift
//  Random Users
//
//  Created by Moses Robinson on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var user: User?
    let fetchQueue = OperationQueue()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else { return }
        
        nameLabel.text = user.name.capitalized
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        let imageOperation = FetchImageOperation(user: user)
        
        let operation = BlockOperation {
            
            guard let image = imageOperation.image else { return }
            
            self.userImageView.image = image
            
        }
        
        operation.addDependency(imageOperation)
        fetchQueue.addOperation(imageOperation)
        OperationQueue.main.addOperation(operation)
        
    }
}
