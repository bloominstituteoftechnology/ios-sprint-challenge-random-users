//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    var userController: UserController?
    
    var user: Result? {
        didSet {
            updateViews()
        }
    }
    
    let cache = Cache<String, Data>()
    
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
    
    func decodePhoto(user: Result) {
        
        let name: String = user.name["first"]! + " " + user.name["last"]!
        
        if let cacheImage = cache.valueLarge(for: name){
            
           self.userFullSizeImage.image = UIImage(data: cacheImage)
            
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
                    self.userFullSizeImage.image = photo
                }
            }
            dataTask.resume()
        }
}
    
    
    @IBOutlet weak var userFullSizeImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    

}
