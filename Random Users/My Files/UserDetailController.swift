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
        createMainView()
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    var currentUser: IndexPath?
    
    
    
    func createMainView() {
        guard let indexPath = currentUser else { return }
        let singleUser = manager.addressbook[indexPath.row]
        let singlePhoto = manager.fullsizes[indexPath.row]
        userName.text = "\(singleUser.name.title). \(singleUser.name.first) \(singleUser.name.last)"
        userEmail.text = singleUser.email
        userPhone.text = singleUser.cell
        userImage.image = singlePhoto
    }
    
}
