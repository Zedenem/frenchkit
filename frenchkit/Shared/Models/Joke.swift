import Foundation

@objc class Joke: NSObject, Codable {
  @objc var id: String
  @objc var text: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case text = "joke"
  }
}
