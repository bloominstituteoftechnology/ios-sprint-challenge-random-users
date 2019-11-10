//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Dillon P on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var person: Person?
    var cache: Cache<String, Data>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func updateViews() {
        guard let person = person else { return }
        
        nameLabel.text = "Name: \(person.name)"
        numberLabel.text = "Phone: \(person.phone)"
        emailLabel.text = "Email: \(person.email)"
    }
    
    func loadImage() {
        
        guard let person = person, let cache = cache else { return }
        
        if let cachedData = cache.value(for: person.pictureURL) {
            if let picture = UIImage(data: cachedData) {
                personImageView.image = picture
                updateViews()
            }
        } else {
            let url = URL(string: person.pictureURL)!
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                
                if let error = error {
                    print("Error fetching image: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.personImageView.image = image
                    self.updateViews()
                }
            }.resume()
        }
    }
}
