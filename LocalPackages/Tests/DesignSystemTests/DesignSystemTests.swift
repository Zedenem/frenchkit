import XCTest

@testable import DesignSystem

class ColorsTests: XCTestCase {
  func testAccentTintColor_hasCorrectValue() {
    XCTAssertEqual(Colors.accentTint, .systemTeal)
  }
}
