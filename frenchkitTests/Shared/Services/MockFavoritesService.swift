@testable import frenchkit
import Model

class MockFavoritesService: FavoritesServicing {
  enum Error: Swift.Error {
    case mockError
  }
  
  var isFavoriteCallCount: Int = 0
  var isFavoriteLastJokeId: String?
  var isFavoriteReturnValue: Bool = false
  func isFavorite(jokeWithId id: String) -> Bool {
    isFavoriteCallCount += 1
    isFavoriteLastJokeId = id
    return isFavoriteReturnValue
  }
  
  var addToFavoritesCallCount: Int = 0
  var addToFavoritesLastJoke: Joke?
  var addToFavoritesError: MockFavoritesService.Error?
  func addToFavorites(joke: Joke) throws {
    addToFavoritesCallCount += 1
    addToFavoritesLastJoke = joke
    if let addToFavoritesError {
      throw addToFavoritesError
    }
  }
  
  var removeFromFavoritesCallCount: Int = 0
  var removeFromFavoritesLastJoke: Joke?
  var removeFromFavoritesError: MockFavoritesService.Error?
  func removeFromFavorites(joke: Joke) throws {
    removeFromFavoritesCallCount += 1
    removeFromFavoritesLastJoke = joke
    if let removeFromFavoritesError {
      throw removeFromFavoritesError
    }
  }
  
  var allFavorites: [Joke] = []
}
