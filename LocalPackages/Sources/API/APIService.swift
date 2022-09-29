import Foundation
import Model

public enum APIServiceError: Error {
  case serverError(Error)
  case invalidRequest
  case noData
}

public protocol APIServicing {
  func fetchTopRated(page: Int) async throws -> TopRatedResponse
}

public class APIService: APIServicing {
  public func fetchTopRated(page: Int) async throws -> TopRatedResponse {
    guard let url = Bundle.module.url(forResource: "topRated_\(page)", withExtension: "json") else {
      throw APIServiceError.invalidRequest
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = TopRatedResponse.keyDecodingStrategy
    return try decoder.decode(TopRatedResponse.self, from: data)
  }
  
  public init() {}
}
