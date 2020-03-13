//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var profilePicIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    private func updateViews() {
        guard let user = user else { return }

        nameLabel?.text = user.name
        telLabel?.text = user.phone
        emailLabel?.text = user.email
        loadLargePic(user: user)
    }
    
    func loadLargePic(user: User) {
        
        let largePicURL = user.picture[1]
        var request = URLRequest(url: largePicURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                NSLog("Error: \(error)")
            }

            guard let data = data else {
                NSLog("Error loading Image")
                return
            }
            
            DispatchQueue.main.async {
                self.profilePicIV?.image = UIImage(data: data)
            }

        }.resume()
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
