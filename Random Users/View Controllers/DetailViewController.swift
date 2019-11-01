//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var users: Users? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var userLargeImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dobAge: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let firstName = users?.name.first,
            let lastName = users?.name.last,
            let age = users?.dob.age,
            let email = users?.email,
            let name = userName,
            let image = users?.picture.large else { return }
        name.text = "\(firstName) \(lastName)"
        dobAge.text = "\(age) years old"
        userEmail.text = "Email: \(email)"
        
        URLSession.shared.dataTask(with: (image)) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching images: \(error)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.userLargeImage.image = UIImage(data: data)
            }
        }.resume()
    }
}

