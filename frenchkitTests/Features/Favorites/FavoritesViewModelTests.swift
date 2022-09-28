import XCTest

@testable import frenchkit

class FavoritesViewModelTests: XCTestCase {
  func testFavorites_updatedAfterInit() {
    let mockFavoritesService = MockFavoritesService()
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    mockFavoritesService.allFavorites = [joke]
    
    let sut = FavoritesViewModel(favoritesService: mockFavoritesService)
    
    XCTAssertEqual(sut.favorites, [joke])
  }
  
  func testFavorites_updatedWhenFavoriteIsAdded() {
    let mockFavoritesService = MockFavoritesService()
    let sut = FavoritesViewModel(favoritesService: mockFavoritesService)
    
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    mockFavoritesService.allFavorites = [joke]
    
    XCTAssertEqual(sut.favorites, [])
    
    NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
    
    XCTAssertEqual(sut.favorites, [joke])
  }
  
  func testRemoveFromFavorites_callsFavoritesService() {
    let mockFavoritesService = MockFavoritesService()
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    mockFavoritesService.allFavorites = [joke]
    let sut = FavoritesViewModel(favoritesService: mockFavoritesService)
    sut.removeFromFavorites(joke: joke)
    
    XCTAssertEqual(mockFavoritesService.removeFromFavoritesCallCount, 1)
    XCTAssertEqual(mockFavoritesService.removeFromFavoritesLastJoke, joke)
  }
}
