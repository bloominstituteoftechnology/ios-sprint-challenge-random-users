import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let url = RandomUserController.shared.requestURL
        RandomUserController.shared.fetchRandomUsers(with: url) {_ in
            return
        }
        
        return true
    }
}



