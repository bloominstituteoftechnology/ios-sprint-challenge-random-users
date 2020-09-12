//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Rob Vance on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Properties -
    var randomUserAPICon: RandomUsersApiController?
    var user: User?
    
    //MARK: - IBOutlets -
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        nameLabel.text = user?.name
        phoneNumberLabel.text = user?.phone
        emailLabel.text = user?.email
        
        do {
            guard let url = user?.largeImage else { return }
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            largeImageView.image = image
        } catch {
            print("error updating: \(error)")
        }
    }
}
