//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kat Milton on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userNumberLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!


    let cache = Cache<String, Data>()
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        view.backgroundColor = AppearanceHelper.mintColor
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = AppearanceHelper.purpleColor.withAlphaComponent(0.7).cgColor
        
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let user = user {
            getPhoto(user: user)
            let name = user.name["title"]!.capitalized + " " + user.name["first"]!.capitalized + " " + user.name["last"]!.capitalized
            userNameLabel.text = name
            
            let number = user.phone
            if number.contains("(") {
                let fixedNumber = number.stringByReplacingFirstOccurrenceOfString(target: "-", withString: " ")
                userNumberLabel.text = fixedNumber
            } else {
                userNumberLabel.text = number
            }
            userEmailLabel.text = user.email
        }
    }
    
    func getPhoto(user: User) {
        let name: String = user.name["first"]! + " " + user.name["last"]!
        
        if let imageFromCache = cache.largePictureValue(for: name) {
            self.userImageView.image = UIImage(data: imageFromCache)
        } else {
            let dataTask = URLSession.shared.dataTask(with: URL(string: user.picture["large"]!)!) { (data, _, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else { return }
    
                let picture = UIImage(data: data)
                self.cache.cacheLargePictures(value: data, for: name)
                
                DispatchQueue.main.async {
                    self.userImageView.image = picture
                }
            }
            dataTask.resume()
        }

    }

}

// Adding String extension to replace the first dash in phone numbers with area codes to spaces instead.
extension String {
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
