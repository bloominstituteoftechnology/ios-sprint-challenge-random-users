//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var localUser: Result? {
        didSet {
            updateViews()
        }
    }
    var imageData: Data?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else {
            return
        }
        guard let localUser = localUser else { return }
        let fullName = "\(localUser.name.title) \(localUser.name.first) \(localUser.name.last)"
        guard let url = URL(string: localUser.picture.large) else { return }
        nameLabel.text = fullName
        emailLabel.text = localUser.email
        phoneLabel.text = localUser.phone
        
        let fetchImageQueue = OperationQueue()
        
        let fetchImageOp = FetchImage(url: url)
        
        let getDataOp = BlockOperation {
            self.imageData = fetchImageOp.imageData
        }
        
        let displayOp = BlockOperation {
            DispatchQueue.main.async {
                guard let imageData = self.imageData else { return }
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        getDataOp.addDependency(fetchImageOp)
        displayOp.addDependency(getDataOp)
        
        fetchImageQueue.addOperations([fetchImageOp, getDataOp, displayOp], waitUntilFinished: false)
    }
}
