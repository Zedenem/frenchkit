@testable import frenchkit
import Model

class MockAPI_ObjcBridge: NSObject, API_ObjcBridging {
  var fetchTopRatedCallCount: Int = 0
  var fetchTopRatedLastPage: Int?
  var topRatedResponse: TopRatedResponse?
  var error: NSError = NSError()
  func fetchTopRated(page: Int) async throws -> TopRatedResponse {
    fetchTopRatedCallCount += 1
    fetchTopRatedLastPage = page
    if let topRatedResponse {
      return topRatedResponse
    }
    throw error
  }
}
