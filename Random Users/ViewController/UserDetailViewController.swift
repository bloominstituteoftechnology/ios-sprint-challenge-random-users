//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private let photoFetchQueue = OperationQueue()
    private var fetchDictionary: [String: Operation] = [:]
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            return
        }
        nameLabel.text = user.first + " " + user.last
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        getImage()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let user = user else { return }
        let operation = fetchDictionary[user.thumbnail]
        operation?.cancel()
    }
    
    func getImage() {
        guard let user = user else {
            return
        }
        
        let photoFetchOperation = FetchUserPhotoOperation(imageURL: user.thumbnail)
        let setUpImageViewOperation = BlockOperation {
            DispatchQueue.main.async {
                
            }
        }
        
        
        setUpImageViewOperation.addDependency(photoFetchOperation)
        photoFetchQueue.addOperations([photoFetchOperation, setUpImageViewOperation], waitUntilFinished: true)
        
        fetchDictionary[user.thumbnail] = photoFetchOperation
    }

}
