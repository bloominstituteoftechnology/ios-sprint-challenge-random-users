//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Properties
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 0
        return sv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - User Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    let photoQueue = OperationQueue()
    var cache: Cache<String, Data>?
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupSubviews()
        updateViews()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Configuration
    private func updateViews() {
        guard let user = user, let cache = cache, self.isViewLoaded else { return }
        title = user.name
        
        if cache.contains(user.detail), let imageData = cache.value(for: user.detail) {
            self.userImageView.image = UIImage(data: imageData)
            self.nameLabel.text = user.name
            self.phoneLabel.text = user.phone
            self.emailLabel.text = user.email
            return
        }
        
        let photoOperation = FetchPhotoOperation(imageURL: user.detail)
        
        let cacheOperation = BlockOperation {
            if let imageData = photoOperation.imageData {
                cache.cache(value: imageData, for: user.detail)
            }
        }
        
        let updateUIOperation = BlockOperation {
            if let imageData = photoOperation.imageData {
                self.userImageView.image = UIImage(data: imageData)
            }
            
            self.nameLabel.text = user.name
            self.phoneLabel.text = user.phone
            self.emailLabel.text = user.email
        }
        
        updateUIOperation.addDependency(photoOperation)
        cacheOperation.addDependency(photoOperation)
        photoQueue.addOperations([photoOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(updateUIOperation)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Subview Configuration
    private func setupSubviews() {
        view.addSubview(userImageView)
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(emailLabel)
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -60),
            userImageView.heightAnchor.constraint(equalToConstant: 300),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor, multiplier: 1),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}
