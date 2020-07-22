//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Kenneth Jones on 7/21/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var person: Contact? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard let contact = person else { return }
        
        downloadImage(from: contact.picture)
        nameLabel.text = contact.name
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.contactImage.image = UIImage(data: data)
            }
        }
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
