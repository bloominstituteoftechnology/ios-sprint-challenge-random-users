//
//  DetailViewController.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var user: User?
    let randomUserFetchQueue = OperationQueue()
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else { return }
        let largeImageOperation = FetchLargeImageOperation(user: user)
        
        let operation = BlockOperation {
            guard let image = largeImageOperation.largeImage else { return }
            self.userImageView.image = image
        }
        
        operation.addDependency(largeImageOperation)
        randomUserFetchQueue.addOperation(largeImageOperation)
        OperationQueue.main.addOperation(operation)
        
        userName.text = user.name
        userPhone.text = user.phone
        userEmail.text = user.email
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
