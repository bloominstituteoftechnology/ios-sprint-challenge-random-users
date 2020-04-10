//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var user: User? { didSet { updateViews() }}
    var thumbnailCache: Cache<URL, Data>? { didSet { updateViews() }}
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private
    
    private weak var loadImageOperation: LoadImageOperation?
    
    private func updateViews() {
        guard let user = user, let cache = thumbnailCache else { return }
        self.nameLabel.text = user.name.fullName
        let loadImageOperation = LoadImageOperation(url: user.picture.thumbnail, imageView: thumbnailImageView, cache: cache)
        OperationQueue.main.addOperation(loadImageOperation)
        self.loadImageOperation = loadImageOperation
    }
    
    override func prepareForReuse() {
        loadImageOperation?.cancel()
        loadImageOperation = nil
        
        user = nil
        thumbnailCache = nil
        thumbnailImageView.image = Images.placeholder
        nameLabel.text = nil
    }
}
