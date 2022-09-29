import XCTest

import API
@testable import frenchkit
import Model

class TopRatedViewModelTests: XCTestCase {
  var sut: TopRatedViewModel!
  var mockAPI_objcBridge: MockAPI_ObjcBridge!
  
  override func setUp() {
    super.setUp()
    mockAPI_objcBridge = MockAPI_ObjcBridge()
    sut = TopRatedViewModel(api: mockAPI_objcBridge)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockAPI_objcBridge = nil
  }
  
  func testJokesListIsEmpty_afterInit() {
    XCTAssertEqual(sut.numberOfJokes, 0)
    XCTAssertNil(sut.joke(at: 0))
  }
  
  func testFetchNextPage_updatesJokesList_whenSuccess() {
    let joke = Joke(id: "aJokeId", text: "aJokeText")
    let topRatedResponse = TopRatedResponse(previousPage: 0, currentPage: 0, nextPage: 1, limit: 10, status: 0,
                                            totalJokes: 1, totalPages: 1, results: [joke, joke])
    mockAPI_objcBridge.topRatedResponse = topRatedResponse
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { newJokes, error in
      XCTAssertEqual(newJokes as? [Joke], topRatedResponse.results)
      XCTAssertNil(error)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
    
    XCTAssertEqual(sut.numberOfJokes, topRatedResponse.results.count)
    XCTAssertEqual(sut.joke(at: 0) as? Joke, topRatedResponse.results[0])
    XCTAssertEqual(sut.joke(at: 1) as? Joke, topRatedResponse.results[1])
  }
  
  func testFetchNextPage_returnsError_whenError() {
    mockAPI_objcBridge.error = APIServiceError.noData as NSError
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { newJokes, error in
      XCTAssertEqual(error as? NSError, self.mockAPI_objcBridge.error)
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
    mockAPI_objcBridge.topRatedResponse = topRatedResponse
    
    let expectation = XCTestExpectation(description: "fetchNextPage should complete.")
    sut.fetchNextPage { _, _ in expectation.fulfill() }
    wait(for: [expectation], timeout: 0.01)
    
    sut.reset()
    
    XCTAssertEqual(sut.numberOfJokes, 0)
  }
}
