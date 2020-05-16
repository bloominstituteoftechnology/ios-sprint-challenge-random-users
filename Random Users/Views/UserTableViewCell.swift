//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    // MARK: - Methods
    
    func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = user.name
        let thumbnailPicture = user.picture[1]
        let request = URLRequest(url: thumbnailPicture)
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data else {
                NSLog("Did not find thumbnail from data")
                return
            }
            if let error = error {
                NSLog("Error fetching thumbnail picture: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
