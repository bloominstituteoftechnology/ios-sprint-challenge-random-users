//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties

    var user: User? {
        didSet {
         updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Methods
    
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
