//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        if let photoURL = user?.image {
            URLSession.shared.dataTask(with: photoURL) { (data, _, error) in
                if let error = error {
                    NSLog("An error occured fetching this photo. \(error) \(error.localizedDescription)")
                    return
                }
                
                guard let imageData = data else {
                    NSLog("No photo data returned")
                    return
                }
                self.detailImageView.image = UIImage(data: imageData)
            }.resume()
        }
        
        
        
        nameLabel.text = "\(user?.title ?? "NO") \(user?.name ?? "USER")"
        phoneNumberLabel.text = user?.phoneNumber
        emailLabel.text = user?.email
    }
    
    
}
