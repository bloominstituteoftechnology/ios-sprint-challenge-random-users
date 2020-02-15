//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    //=======================
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //=======================
    // MARK: - Properties
    var user: User?
    var imageData: Data?
    weak var delegate: FetchUsersTableViewController?
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        guard let user = user else { return }
        nameLabel.text = "\(user.fname) \(user.lname)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        fetchAndSetImage()
    }
    
    //=======================
    // MARK: - Helper Methods
    func fetchAndSetImage() {
        guard let user = user else { return }
        if let imageData = imageData {
            imageView.image = UIImage(data: imageData)
        } else {
            let photoOp = UserImageFetchOperation(user: user)
            photoOp.fetchPhoto(imageType: .largeImage)
            let setImgOp = BlockOperation {
                if let imageData = photoOp.imageData {
                    DispatchQueue.main.async {
                        self.delegate?.saveToCache(value: imageData, for: user.phone)
                        self.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
            setImgOp.addDependency(photoOp)
            
            OperationQueue.main.addOperations([
                photoOp,
                setImgOp
            ], waitUntilFinished: false)
        }
    }
    
}
