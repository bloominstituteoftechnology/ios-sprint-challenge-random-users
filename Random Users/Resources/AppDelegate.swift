import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let usersTableVC = UsersTableViewController(nibName: nil, bundle: nil)
        window?.rootViewController = UINavigationController(rootViewController: usersTableVC)
        window?.makeKeyAndVisible()
        return true
    }
}

