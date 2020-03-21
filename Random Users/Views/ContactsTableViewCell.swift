//
//  ContactsTableViewCell.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    // IB Outlets
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var contact: Result? {
        didSet {
            updateViews()
        }
    }
    
    // update views
    func updateViews() {
        guard let contact = contact else { return }
        nameLabel.text = contact.name
        let thumbnail = contact.picture[1]
        let request = URLRequest(url: thumbnail)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("error fetching thumbnail: \(error)")
                return
            }
            guard let data = data else {
                print("No Thumbnail data avail")
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImage.image = UIImage(data: data)
            }
        }.resume()
    }

}
