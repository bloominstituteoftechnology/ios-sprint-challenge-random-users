import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var indexPath = IndexPath()
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet var userPicture: UIImageView!
    @IBOutlet var userName: UILabel!
    
    
    // MARK: - Functions
    
    func updateViews() {
        #warning("Never Added Image")
        
        userName.text = user?.name.fullName
    }
}
