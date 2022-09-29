import Foundation

@objc public class Joke: NSObject, Codable, Identifiable {
  @objc public var id: String
  @objc public var text: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case text = "joke"
  }
  
  public init(id: String, text: String) {
    self.id = id
    self.text = text
  }
}
