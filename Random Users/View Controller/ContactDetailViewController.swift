//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Fabiola S on 11/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Method
    
    private func updateViews() {
        guard let user = self.user,
            isViewLoaded else { return }
        
        self.nameLabel.text = user.name
        self.emailLabel.text = user.email
        self.phoneLabel.text = user.phone
        
        let url = user.largeImage
        if let data = try? Data(contentsOf: url) {
            self.contactImage.image = UIImage(data: data)
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
