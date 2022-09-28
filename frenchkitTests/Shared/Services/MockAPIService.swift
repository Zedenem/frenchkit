@testable import frenchkit

class MockAPIService: APIServicing {
  var objc_fetchTopRatedCallCount: Int = 0
  var objc_fetchTopRatedLastPage: Int?
  var completionTopRatedResponse: TopRatedResponse?
  var completionError: NSError?
  func objc_fetchTopRated(page: Int, completion: @escaping (TopRatedResponse?, NSError?) -> Void) {
    objc_fetchTopRatedCallCount += 1
    objc_fetchTopRatedLastPage = page
    completion(completionTopRatedResponse, completionError)
  }
}
