import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var user: User?

    //MARK: - Outlets
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
    }
    
    func updateViews() {
        if let user = user {
        nameLabel.text = "\(user.firstName ) && \(user.lastName)"
        }
    }
}
