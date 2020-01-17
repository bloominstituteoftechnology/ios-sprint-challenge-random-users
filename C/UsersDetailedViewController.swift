//
//  UsersDetailedViewController.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailedViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var userNumberLabel: UILabel!
    
    
    let pictureCache = PictureCache<String, Data>()
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        if let user = user {
            fetchPicture(user: user)
            let name = user.name["title"]!.capitalized + " " + user.name["first"]!.capitalized + " " + user.name["last"]!.capitalized
            userNameLabel.text = name
            let number = user.phone
            userNumberLabel.text = number
            userEmailLabel.text = user.email
        }
    }
    
    func fetchPicture(user: User) {
        let name: String = user.name["first"]! + " " + user.name["last"]!
        
        if let imageFromCache = pictureCache.largePictureValue(for: name) {
            self.userImageView.image = UIImage(data: imageFromCache)
        } else {
            let dataTask = URLSession.shared.dataTask(with: URL(string: user.picture["large"]!)!) { (data, _, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else { return }
                let picture = UIImage(data: data)
                self.pictureCache.cacheLargePictures(value: data, for: name)
                
                DispatchQueue.main.async {
                    self.userImageView.image = picture
                }
            }
            dataTask.resume()
        }
        
    }
    
}
