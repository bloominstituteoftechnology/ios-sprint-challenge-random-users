//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {

    
    
    var randomUser: RandomUser?
    
    @IBOutlet weak var userLargImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        
        guard let title = randomUser?.title, let first = randomUser?.first, let last = randomUser?.last else { return }
        guard let largeimageURL = randomUser?.largeImageURL else { fatalError("largeImageURL fetching error") }
        let url = largeimageURL
        userNameLabel.text = "  \(title.capitalized)  \(first.capitalized) \(last.capitalized)"
        userEmailLabel.text = "  Email:   \(randomUser?.emailAddress ?? "")"
        userPhoneNumber.text = "  Phone: \(randomUser?.phoneNumber ?? "")"
        guard let image = try? Data(contentsOf: url) else { return }
        userLargImage.image = UIImage(data: image)
        
    }
    
}
