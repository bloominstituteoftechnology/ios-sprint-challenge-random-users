import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let detailUser = detailUser,
            
        let imageUrl = detailUser.large else { return }
        imageView.load(url: imageUrl)
        
        nameLabel.text = detailUser.name
        phoneLabel.text = "Phone: \(detailUser.phone)"
        emailLabel.text = "Email: \(detailUser.email)"
    }
    
    var detailUser: User? = nil
    let userController: UserController? = nil
}
