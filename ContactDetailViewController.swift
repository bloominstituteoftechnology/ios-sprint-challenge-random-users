//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController
{
    var person: Person?
    {
        didSet
        {
            guard let person = person else { return }
            imageView.loadImageUsingCacheWithUrlString(person.picture.large)
            nameLabel.text = "\(person.name.title) \(person.name.first) \(person.name.last)"
            emailLabel.text = person.email
        }
    }
    
    let imageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        
        return label
    }()
    
    let emailLabel: UILabel =
    {
        let label = UILabel()
        label.sizeToFit()
        
        return label
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews()
    {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 400)
        
        nameLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 30, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        emailLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    
}





















