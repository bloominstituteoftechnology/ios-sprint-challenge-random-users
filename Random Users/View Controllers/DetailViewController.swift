//
//  DetailViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
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
        userNameLabel.text = user.name.title
        userEmailLabel.text = user.email
        phoneNumberLabel.text = user.phone
        guard let imageURL = try? Data(contentsOf: user.picture.imageURL) else { fatalError() }
        userImageView.image = UIImage(data: imageURL)
    }

    
}
