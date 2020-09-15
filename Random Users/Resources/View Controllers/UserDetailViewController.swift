//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var contact: Contact?
    let cache = Cache<String, Data>()
    var networkingController : NetworkingController?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let contact = contact else {return}
        
        let fullName: String = ("\(contact.name.first) \(contact.name.last)")
        
        nameLabel.text = fullName
        emailLabel.text = contact.email
        phoneLabel.text = contact.phone
        
        if let cachedImage = cache.getValue(key: contact.email),
            let image = UIImage(data: cachedImage) {
            userImageView.image = image
        }
        fetchImage()
        
    }
    
    private func fetchImage() {
        guard let contact = contact, let networkingController = networkingController else { return }
        networkingController.getImage(contact.picture.large, completion: { (result) in
            do {
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.setValue(value: imageString, key: contact.email)
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            } catch {
                NSLog("Error fetching image")
            }
        })
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
