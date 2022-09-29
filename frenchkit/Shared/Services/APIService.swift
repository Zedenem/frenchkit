import Foundation
import Model

enum APIServiceError: Error {
  case serverError(Error)
  case invalidRequest
  case noData
}

@objc protocol APIServicing {
  func objc_fetchTopRated(page: Int, completion: @escaping (TopRatedResponse?, NSError?) -> Void)
}

@objc class APIService: NSObject, APIServicing {
  @objc func objc_fetchTopRated(page: Int, completion: @escaping (TopRatedResponse?, NSError?) -> Void) {
    fetchTopRated(page: page) { result in
      switch result {
      case let .success(topRatedResponse): completion(topRatedResponse, nil)
      case let.failure(error): completion(nil, error as NSError)
      }
    }
  }
  
  func fetchTopRated(page: Int, completion: @escaping (Result<TopRatedResponse, Error>) -> Void) {
    completion(.init {
      guard let url = Bundle.main.url(forResource: "topRated_\(page)", withExtension: "json") else {
        throw APIServiceError.invalidRequest
      }
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = TopRatedResponse.keyDecodingStrategy
      return try decoder.decode(TopRatedResponse.self, from: data)
    })
  }
}
