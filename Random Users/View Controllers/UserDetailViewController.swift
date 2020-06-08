//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    let apiController = APIController()
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        updateViews()
        super.viewDidLoad()
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        guard let user = user else {
            return
        }
        
        apiController.getDetail(url: user.detailImage) { result in
            do {
                let detailImage = try result.get()
                self.detailImage.image = detailImage
            } catch {
                NSLog("Something went wrong setting the result of call to apicontroller for detail image.")
            }
        }
        
        nameLabel.text = "\(user.title) \(user.name)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
    }
}
