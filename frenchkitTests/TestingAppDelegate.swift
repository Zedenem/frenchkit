import UIKit

@objc(TestingAppDelegate)
final class TestingAppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    /// Remove any cached scene configurations to ensure that
    /// TestingAppDelegate.application(_:configurationForConnecting:options:) is called and
    /// TestingSceneDelegate will be used when running unit tests.
    ///
    /// NOTE: THIS IS PRIVATE API AND MAY BREAK IN THE FUTURE!
    for sceneSession in application.openSessions {
      application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
    }
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = TestingSceneDelegate.self
    sceneConfiguration.storyboard = nil
    
    return sceneConfiguration
  }
}

class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
//    window?.rootViewController = TestingRootViewController()
    window?.makeKeyAndVisible()
  }
}
