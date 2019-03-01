//Frulwinn

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - Properties
    static let reuseIdentifier = "userCell"
    var user: User? {
        didSet {
            updateViews()
        }
    }
    var indexPath: IndexPath?
    
    //MARK: - Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func updateViews() {
        if let user = user {
        nameLabel.text = "\(user.title.capitalized) \(user.firstName.capitalized) \(user.lastName.capitalized)"
        }
    }
    
    override func prepareForReuse() {
        userImage.image = nil
        indexPath = nil
        super.prepareForReuse()
    }
}
