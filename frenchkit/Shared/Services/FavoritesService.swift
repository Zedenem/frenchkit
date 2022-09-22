import Foundation

protocol FavoritesServicing {
  func isFavorite(jokeWithId: String) -> Bool
  func addToFavorites(joke: Joke) throws
  func removeFromFavorites(joke: Joke) throws
  
  var allFavorites: [Joke] { get }
}

extension Notification.Name {
  static var didUpdateFavorites = Notification.Name("DidUpdateFavorites")
}

@objc class FavoritesService: NSObject, FavoritesServicing {
  enum Error: Swift.Error {
    case alreadyAdded
    case nothingToRemove
  }
  
  @objc static let shared = FavoritesService()
  
  private var favorites: [String: Joke] = [:]
  
  @objc func isFavorite(jokeWithId id: String) -> Bool {
    favorites.keys.contains(id)
  }
  
  @objc func addToFavorites(joke: Joke) throws {
    guard !isFavorite(jokeWithId: joke.id) else {
      throw Error.alreadyAdded
    }
    favorites[joke.id] = joke
    
    NotificationCenter.default.post(name: .didUpdateFavorites, object: self)
  }
  
  @objc func removeFromFavorites(joke: Joke) throws {
    guard isFavorite(jokeWithId: joke.id) else {
      throw Error.nothingToRemove
    }
    favorites.removeValue(forKey: joke.id)
    
    NotificationCenter.default.post(name: .didUpdateFavorites, object: self)
  }
  
  var allFavorites: [Joke] {
    Array(favorites.values)
  }
}
