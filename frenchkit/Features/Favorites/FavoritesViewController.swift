import SwiftUI
import UIKit

class FavoritesViewController: UIHostingController<FavoritesView> {
  init() {
    super.init(rootView: FavoritesView())
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
