//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        setImage()
    }
    
    private func setImage() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
