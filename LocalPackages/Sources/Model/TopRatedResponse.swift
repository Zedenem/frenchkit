import Foundation

@objc public class TopRatedResponse: NSObject, Codable {
  public static let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
  
  let previousPage: Int
  let currentPage: Int
  @objc public let nextPage: Int
  
  let limit: Int
  let status: Int
  let totalJokes: Int
  let totalPages: Int
  
  @objc public let results: [Joke]
  
  public init(previousPage: Int, currentPage: Int, nextPage: Int, limit: Int, status: Int, totalJokes: Int, totalPages: Int, results: [Joke]) {
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
