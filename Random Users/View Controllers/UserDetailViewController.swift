//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var user: Result? {
           didSet {
               updateViews()
           }
       }
    
    @IBOutlet weak var userBigImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let cache = Cache<String, Data>()
    var userController: UserController?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func decodePhoto(user: Result) {
            
        let name: String = user.name["first"]! + " " + user.name["last"]!
        if let cacheImage = cache.valueLarge(for: name){
                
        self.userBigImage.image = UIImage(data: cacheImage)
                
        } else {
                
        let dataTask = URLSession.shared.dataTask(with: URL(string: user.picture["large"]!)!) { (photoData, _, error) in
                
        if let error = error {
            print("Error: \(error)")
            return
        }
          guard let photoData = photoData else { return }
            let photo = UIImage(data: photoData)
                
            self.cache.cacheLarge(value: photoData, for: name)
                    
            DispatchQueue.main.async {
            self.userBigImage.image = photo
            }
        }
        dataTask.resume()
    }
}

  func updateViews() {
        guard isViewLoaded else { return }
        
        if let user = user {
            decodePhoto(user: user)
            
            let name: String = user.name["first"]!.capitalized + " " + user.name["last"]!.capitalized
            
            nameLabel.text = name
            phoneNumberLabel.text = user.phone
            emailLabel.text = user.email
            
        }
        
    }

}
