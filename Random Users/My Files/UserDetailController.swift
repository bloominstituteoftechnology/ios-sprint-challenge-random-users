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
        setPhoto(indexPath: currentUser!)
    
        createMainView()
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    var currentUser: IndexPath?


    private var image: UIImage? { didSet {
        
        userImage.image = image //Assigns to outlet above
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true } }
    
    
    func createMainView() {
        guard let indexPath = currentUser else { return }
        let singleUser = manager.addressbook[indexPath.row]
        //let singlePhoto = manager.fullsizes[indexPath.row]
        userName.text = "\(singleUser.name.title). \(singleUser.name.first) \(singleUser.name.last)"
        userEmail.text = singleUser.email
        userPhone.text = singleUser.cell
        
    }
    
    func setPhoto(indexPath: IndexPath) {
        guard let photoURL = URL(string: manager.addressbook[indexPath.row].picture.large) else { return }
        Cache.checkImage(url: photoURL) { cacheimage in
            self.image = cacheimage

        }
    }
    
}
