import UIKit

class DetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var person: User? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPhoneLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    
    // MARK: - Functions
    
    private func updateViews() {
        if let person = person {
            print("Person Found \(person.name.fullName)")
            
            personNameLabel?.text = person.name.fullName
            personPhoneLabel?.text = person.phone
            personEmailLabel?.text = person.email
        }
    }
}
