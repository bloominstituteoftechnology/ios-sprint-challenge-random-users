//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var user: User? { didSet { updateViews() }}
    var cache: Cache<URL, Data>?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private
    var loadImageOperation: LoadImageOperation?
    
    func updateViews() {
        guard let user = user, let cache = cache else { return }
        self.nameLabel.text = user.name.title + " " + user.name.first + " " + user.name.last
        loadImageOperation = LoadImageOperation(url: user.picture.thumbnail, imageView: thumbnailImageView, cache: cache)
        OperationQueue.main.addOperation(loadImageOperation!)
    }
    
    override func prepareForReuse() {
        loadImageOperation?.cancel()
        user = nil
    }
}
