//
//  DetailViewController.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    var name: Name?
    var picture: Picture?
    var userImage: Data?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateViews()
    }

    private func updateViews() {
        guard let title = user?.name, let name = name?.firstName else { return }
        
        userNameLabel?.text = "\(title) \(name)"
        userPhoneLabel?.text = user?.phone
        userEmailLabel?.text = user?.email
        
        //if let picture = userImage {
            //userImageView?.image = UIImage(data: picture)
        let url = URL(string: (picture!.large?.absoluteString)!)
        let data = try? Data(contentsOf: url!)
        
        userImageView.image = UIImage(data: data!)
        //}
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
///////end
}
