//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var userImage: Data?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var phoneTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        guard let title = user?.title, let name = user?.name else { return }
        
        nameTextLabel?.text = "\(title) \(name)"
        phoneTextLabel?.text = user?.phone
        emailTextLabel?.text = user?.email
        
        if let picture = userImage {
            userImageView?.image = UIImage(data: picture)
        }
    }

}
