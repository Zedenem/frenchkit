import XCTest

@testable import frenchkit

class FavoritesServiceTests: XCTestCase {
  var sut: FavoritesService!
  
  override func setUp() {
    super.setUp()
    sut = FavoritesService()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
}

// MARK: - addToFavorites
extension FavoritesServiceTests {
  func testAddToFavorites_correctlyAddsJoke() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    
    XCTAssertNoThrow(try sut.addToFavorites(joke: joke))
    
    XCTAssertTrue(sut.isFavorite(jokeWithId: joke.id))
    XCTAssertEqual(sut.allFavorites, [joke])
  }
  
  func testAddToFavorites_throws_whenJokeWithSameIdAlreadyExists() {
    let joke1 = Joke(id: "aJokeId", text: "aJokeText")
    let joke2 = Joke(id: joke1.id, text: "anotherJokeText")
    
    try? sut.addToFavorites(joke: joke1)
    XCTAssertThrowsError(try sut.addToFavorites(joke: joke2)) { error in
      XCTAssertEqual(error as? FavoritesService.Error, .alreadyAdded)
    }
    
    XCTAssertTrue(sut.isFavorite(jokeWithId: joke1.id))
    XCTAssertEqual(sut.allFavorites, [joke1])
  }
  
  func testAddToFavorites_postsNotification_whenJokeIsAdded() {
    let expectation = XCTestExpectation(description: "notification should be received")
    NotificationCenter.default.addObserver(forName: .didUpdateFavorites,
                                           object: nil,
                                           queue: .main) { _ in
      expectation.fulfill()
    }
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    
    try? sut.addToFavorites(joke: joke)
    
    wait(for: [expectation], timeout: 0.01)
  }
}

// MARK: - isFavorite
extension FavoritesServiceTests {
  func testIsFavorite_returnsFalse_withEmptyString() {
    let observed = sut.isFavorite(jokeWithId: "")
    XCTAssertFalse(observed)
  }
  
  func testIsFavorite_returnsFalse_withUnknownId() {
    let observed = sut.isFavorite(jokeWithId: "aJokeId")
    XCTAssertFalse(observed)
  }
}

// MARK: - removeFromFavorites
extension FavoritesServiceTests {
  func testRemoveFromFavorites_correctlyRemovesJoke() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    
    try? sut.addToFavorites(joke: joke)
    
    XCTAssertNoThrow(try sut.removeFromFavorites(joke: joke))
    
    XCTAssertFalse(sut.isFavorite(jokeWithId: joke.id))
    XCTAssertEqual(sut.allFavorites, [])
  }
  
  func testRemoveFromFavorites_throws_whenJokeIsNotInFavorites() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    
    XCTAssertThrowsError(try sut.removeFromFavorites(joke: joke)) { error in
      XCTAssertEqual(error as? FavoritesService.Error, .nothingToRemove)
    }
    
    XCTAssertFalse(sut.isFavorite(jokeWithId: joke.id))
    XCTAssertEqual(sut.allFavorites, [])
  }
}

// MARK: - allFavorites
extension FavoritesServiceTests {
  func testAllFavorites_returnsEmptyArray_whenNoJokes() {
    XCTAssertEqual(sut.allFavorites, [])
  }
  
  func testAllFavorites_returnsCorrectArray_whenAddingOneJoke() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    
    try? sut.addToFavorites(joke: joke)
    
    XCTAssertEqual(sut.allFavorites, [joke])
  }
  
  func testAllFavorites_returnsCorrectArrayWithoutPreservingOrder_whenAddingMultipleJokes() {
    let joke1 = Joke(id: "1", text: "aJokeText")
    let joke2 = Joke(id: "2", text: "aJokeText")
    let joke3 = Joke(id: "3", text: "aJokeText")
    
    try? sut.addToFavorites(joke: joke1)
    try? sut.addToFavorites(joke: joke2)
    try? sut.addToFavorites(joke: joke3)
    
    XCTAssertEqual(Set(sut.allFavorites), Set([joke1, joke2, joke3]))
  }
}
