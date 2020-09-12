//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by ronald huston jr on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    //  outlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //  MARK: - properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    

    // MARK: - methods
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        title = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        guard let imageData = try? Data(contentsOf: user.large!) else { fatalError() }
        imageView.image = UIImage(data: imageData)
    }


}
