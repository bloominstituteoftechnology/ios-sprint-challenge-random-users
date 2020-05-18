import UIKit

class DetailViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    // MARK: - Properties
    
    var person: User? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Functions
    
    private func updateViews() {
        guard let user = person else {
            print("No Person Data")
            return
        }

        print("Person Found \(user.name.fullName)")
        #warning("Didn't add photos")

        userName.text = "Hello"
//        userPhone.text = user.phone
//        userEmail.text = user.email
    }
}
