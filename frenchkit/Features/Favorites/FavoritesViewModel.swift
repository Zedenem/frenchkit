import Foundation
import Model

class FavoritesViewModel: ObservableObject {
  @Published var favorites: [Joke]
  
  private let favoritesService: FavoritesServicing
  
  init(favoritesService: FavoritesServicing) {
    self.favoritesService = favoritesService
    favorites = self.favoritesService.allFavorites
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didUpdateFavorites),
                                           name: .didUpdateFavorites,
                                           object: nil)
  }
  
  @objc private func didUpdateFavorites() {
    favorites = self.favoritesService.allFavorites
  }
  
  @Published var jokeToRemoveFromFavorite: Joke?
  func removeFromFavorites(joke: Joke) {
    try? favoritesService.removeFromFavorites(joke: joke)
  }
}
