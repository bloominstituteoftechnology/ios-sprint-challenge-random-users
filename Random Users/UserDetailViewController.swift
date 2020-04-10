//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - Public Properties
    var user: User?
    var imageCache: Cache<URL, Data>?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loadImageOperation?.cancel()
    }
    
    // MARK: - Private
    
    private var loadImageOperation: LoadImageOperation?
    
    private func updateViews() {
        guard let user = user, let imageCache = imageCache else { return }
        self.nameLabel.text = user.name.title + " " + user.name.first + " " + user.name.last
        self.phoneNumberLabel.text = user.phone
        self.emailLabel.text = user.email
        
        loadImageOperation = LoadImageOperation(url: user.picture.large, imageView: imageView, cache: imageCache)
        OperationQueue.main.addOperation(loadImageOperation!)
    }
}
