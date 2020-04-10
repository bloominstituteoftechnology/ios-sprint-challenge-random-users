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
    
    var loadImageOperation: LoadImageOperation?
    
    func updateViews() {
        guard let user = user, let cache = thumbnailCache else { return }
        self.nameLabel.text = user.name.fullName
        loadImageOperation = LoadImageOperation(url: user.picture.thumbnail, imageView: thumbnailImageView, cache: cache)
        OperationQueue.main.addOperation(loadImageOperation!)
    }
    
    override func prepareForReuse() {
        loadImageOperation?.cancel()
        loadImageOperation = nil
        
        user = nil
        thumbnailCache = nil
        thumbnailImageView.image = nil
        nameLabel.text = nil
    }
}
