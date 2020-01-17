//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Subview Configuration
    private func setupSubviews() {
        contentView.addSubview(personImageView)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            personImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            personImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            personImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            personImageView.heightAnchor.constraint(equalToConstant: 50),
            personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Configuration
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
    }
}
