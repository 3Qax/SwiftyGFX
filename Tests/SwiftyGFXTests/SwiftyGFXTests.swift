import XCTest
@testable import SwiftyGFX

final class SwiftyGFXTests: XCTestCase {
    
    func testLineTypeDetecting() {
        let startPoint = Point(x: 0, y: 0)
        let pointToBottom = Point(x: 0, y: 5)
        let pointToRight = Point(x: 5, y: 0)
        
        // X - - - - X
        // |       /
        // |     /
        // |   /
        // | /
        // X
        
        let horizontalLine = Line(from: startPoint, to: pointToRight)
        XCTAssertEqual(horizontalLine.type, .horizontal)
        let horizontalLine2 = Line(from: startPoint, width: 5)
        XCTAssertEqual(horizontalLine2.type, .horizontal)
        
        let verticalLine = Line(from: startPoint, to: pointToBottom)
        XCTAssertEqual(verticalLine.type, .vertical)
        let verticalLine2 = Line(from: startPoint, height: 5)
        XCTAssertEqual(verticalLine2.type, .vertical)
        
        let obliqueLine = Line(from: pointToBottom, to: pointToRight)
        XCTAssertEqual(obliqueLine.type, .oblique)
        
    }
    
    static var allTests = [
        ("testLineTypeDetecting", testLineTypeDetecting),
    ]
}

