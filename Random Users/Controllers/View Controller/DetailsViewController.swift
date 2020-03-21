//
//  DetailsViewController.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var contacts: Result?
    
    
    // IBOutlets
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    func updateViews() {
        guard let contacts = contacts else { return }
        nameLabel.text = contacts.name
        phoneLabel.text = contacts.phone
        emailLabel.text = contacts.email
        
        // image
        let largeImage = contacts.picture[0]
        let request = URLRequest(url: largeImage)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("error fetching large image: \(error)")
                return
            }
            guard let data = data else {
                print("error with image data: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.largeImage.image = UIImage(data: data)
            }
        }.resume()
        
    }

}
