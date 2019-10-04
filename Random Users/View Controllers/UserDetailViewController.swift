//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var apiController: APIController?
    var photoFetchQueue = OperationQueue()
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        title = user.name.first.capitalized + " " + user.name.last.capitalized
        nameLabel.text = user.name.first.capitalized + " " + user.name.last.capitalized
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        guard let imageData = try? Data(contentsOf: user.picture.thumbnail) else { fatalError() }
        imageView.image = UIImage(data: imageData)
    }
}
