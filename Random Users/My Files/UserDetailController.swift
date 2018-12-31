//
//  UserDetailController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserDetailController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        guard let photoURL = URL(string: manager.addressbook[currentUser!.row].picture.large) else { return }
        
        DispatchQueue.main.async {
            self.cache.loadImages(url: photoURL) { image in self.image = image }
        }

        createMainView()
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    var currentUser: IndexPath?
    var cache: Cache!

    private var image: UIImage? { didSet {
        DispatchQueue.main.async {
            self.userImage.image = self.image //Assigns to outlet above
        }
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true } }
    
    
    func createMainView() {
        guard let indexPath = currentUser else { return }
        let singleUser = manager.addressbook[indexPath.row]
        //let singlePhoto = manager.fullsizes[indexPath.row]
        userName.text = "\(singleUser.name.title). \(singleUser.name.first) \(singleUser.name.last)"
        userEmail.text = singleUser.email
        userPhone.text = singleUser.cell
        
        
        
        
        //userImage.image = singlePhoto
    }
    
}
