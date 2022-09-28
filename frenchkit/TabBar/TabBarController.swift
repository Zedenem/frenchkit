import UIKit

@objc class TabBarController: UITabBarController {
  @objc init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .primaryBackground
    tabBar.backgroundColor = .barBackground
    tabBar.tintColor = .selectedTint
    tabBar.unselectedItemTintColor = .unselectedTint
    
    self.viewControllers = [makeTopRated(), makeFavorites()]
  }
}

// MARK: - Make Tabs
extension TabBarController {
  private func makeTopRated() -> UIViewController {
    let vc = TopRatedViewController(api: APIService())
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    vc.navigationItem.title = "Top Rated"
    nav.tabBarItem = UITabBarItem(title: "Top Rated",
                                  image: UIImage(systemName: "newspaper"),
                                  selectedImage: UIImage(systemName: "newspaper.fill"))
    return nav
  }
  
  private func makeFavorites() -> UIViewController {
    let vc = FavoritesViewController()
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    vc.navigationItem.title = "Favorites"
    nav.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
    return nav
  }
}
