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
}
