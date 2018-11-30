//
//  DetailVC.swift
//  Random Users
//
//  Created by Nikita Thomas on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    
    var user: User?
    let userFetchQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else { return }
        let op1 = FetchPhotoOperation(user: user, imageType: .large)
        let op2 = BlockOperation {
            guard let image = op1.image else { return }
            self.detailImageView.image = image
        }
        op2.addDependency(op1)
        
        userFetchQueue.addOperation(op1)
        OperationQueue.main.addOperation(op2)
        
        nameLabel.text = user.name
        phoneLabel.text = user.phoneNumber
        emailLabel.text = user.emailAddress
    }
}

