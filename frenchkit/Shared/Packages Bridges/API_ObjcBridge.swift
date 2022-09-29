import API
import Foundation
import Model

@objc protocol API_ObjcBridging: NSObjectProtocol {
  func fetchTopRated(page: Int) async throws -> TopRatedResponse
}

@objc class API_ObjcBridge: NSObject, API_ObjcBridging {
  @objc func fetchTopRated(page: Int) async throws -> TopRatedResponse {
    try await APIService().fetchTopRated(page: page)
  }
}
