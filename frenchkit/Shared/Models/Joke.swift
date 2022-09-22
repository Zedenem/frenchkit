import Foundation

@objc class Joke: NSObject, Codable, Identifiable {
  @objc var id: String
  @objc var text: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case text = "joke"
  }
  
  init(id: String, text: String) {
    self.id = id
    self.text = text
  }
}
