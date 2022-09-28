import Foundation

@objc class TopRatedResponse: NSObject, Codable {
  static let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  
  let previousPage: Int
  let currentPage: Int
  @objc let nextPage: Int
  
  let limit: Int
  let status: Int
  let totalJokes: Int
  let totalPages: Int
  
  @objc let results: [Joke]
  
  init(previousPage: Int, currentPage: Int, nextPage: Int, limit: Int, status: Int, totalJokes: Int, totalPages: Int, results: [Joke]) {
    self.previousPage = previousPage
    self.currentPage = currentPage
    self.nextPage = nextPage
    self.limit = limit
    self.status = status
    self.totalJokes = totalJokes
    self.totalPages = totalPages
    self.results = results
  }
}
