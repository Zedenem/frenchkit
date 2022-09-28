import XCTest

@testable import frenchkit

class TopRatedViewModelTests: XCTestCase {
  var sut: TopRatedViewModel!
  var mockAPIService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    mockAPIService = MockAPIService()
    sut = TopRatedViewModel(api: mockAPIService)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockAPIService = nil
  }
  
  func testJokesListIsEmpty_afterInit() {
    XCTAssertEqual(sut.numberOfJokes, 0)
    XCTAssertNil(sut.joke(at: 0))
  }
  
  func testFetchNextPage_updatesJokesList_whenSuccess() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    let topRatedResponse = TopRatedResponse(previousPage: 0, currentPage: 0, nextPage: 1, limit: 10, status: 0,
                                            totalJokes: 1, totalPages: 1, results: [joke, joke])
    mockAPIService.completionTopRatedResponse = topRatedResponse
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { newJokes, error in
      XCTAssertEqual(newJokes, topRatedResponse.results)
      XCTAssertNil(error)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
    
    XCTAssertEqual(sut.numberOfJokes, topRatedResponse.results.count)
    XCTAssertEqual(sut.joke(at: 0), topRatedResponse.results[0])
    XCTAssertEqual(sut.joke(at: 1), topRatedResponse.results[1])
  }
  
  func testFetchNextPage_returnsError_whenError() {
    mockAPIService.completionError = APIServiceError.noData as NSError
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { newJokes, error in
      XCTAssertEqual(error as? NSError, self.mockAPIService.completionError)
      XCTAssertNil(newJokes)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
    
    XCTAssertEqual(sut.numberOfJokes, 0)
  }
  
  func testResets_removesAllJokes() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    let topRatedResponse = TopRatedResponse(previousPage: 0, currentPage: 0, nextPage: 1, limit: 10, status: 0,
                                            totalJokes: 1, totalPages: 1, results: [joke, joke, joke])
    mockAPIService.completionTopRatedResponse = topRatedResponse
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { _, _ in expectation.fulfill() }
    wait(for: [expectation], timeout: 0.01)
    
    sut.reset()
    
    XCTAssertEqual(sut.numberOfJokes, 0)
  }
}
