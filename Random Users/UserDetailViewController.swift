//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var networkClient: Client?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    func updateViews() {
        guard let user = user else { return }
        userName.text = "\(user.title). \(user.first) \(user.last)"
        userNumber.text = user.phone
        userEmail.text = user.email
        
        
        
        
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
