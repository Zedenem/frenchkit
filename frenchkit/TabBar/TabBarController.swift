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
    
    view.backgroundColor = .systemBackground
    tabBar.backgroundColor = .tertiarySystemBackground
    tabBar.tintColor = .label
    tabBar.unselectedItemTintColor = .tertiaryLabel
    
    self.viewControllers = [makeTopRated(),
                            makeSearch(),
                            makeFavorites()]
  }
}

// MARK: - Make Tabs
extension TabBarController {
  private func makeTopRated() -> UIViewController {
    let vc = TopRatedViewController(api: APIService())
    let nav = UINavigationController(rootViewController: vc)
    vc.navigationItem.title = "Home"
    nav.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
    return nav
  }
  
  private func makeSearch() -> UIViewController {
    let vc = SearchViewController()
    let nav = UINavigationController(rootViewController: vc)
    vc.navigationItem.title = "Search"
    nav.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
    return nav
  }
  
  private func makeFavorites() -> UIViewController {
    let vc = FavoritesViewController()
    let nav = UINavigationController(rootViewController: vc)
    vc.navigationItem.title = "Favorites"
    nav.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
    return nav
  }
}
