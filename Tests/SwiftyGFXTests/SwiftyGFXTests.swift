import XCTest
@testable import SwiftyGFX

final class SwiftyGFXTests: XCTestCase {
    
    func testObliqueLineDrawing() {
        
        XCTAssertEqual(pointsForLine(from: Point(x: 0, y: 0), to: Point(x: 3, y: 3)),
                       [Point(x: 0, y: 0), Point(x: 1, y: 1), Point(x: 2, y: 2), Point(x: 3, y: 3)])
        
        XCTAssertEqual(pointsForLine(from: Point(x: 0, y: 0), to: Point(x: 10, y: 8)),
                       [Point(x: 0, y: 0), Point(x: 1, y: 1), Point(x: 2, y: 2), Point(x: 3, y: 2),
                        Point(x: 4, y: 3), Point(x: 5, y: 4), Point(x: 6, y: 5), Point(x: 7, y: 6),
                        Point(x: 8, y: 6), Point(x: 9, y: 7), Point(x: 10, y: 8)])
        
        XCTAssertEqual(pointsForLine(from: Point(x: 0, y: 0), to: Point(x: -10, y: -8)),
                       [Point(x: 0, y: 0), Point(x: -1, y: -1), Point(x: -2, y: -2), Point(x: -3, y: -2),
                        Point(x: -4, y: -3), Point(x: -5, y: -4), Point(x: -6, y: -5), Point(x: -7, y: -6),
                        Point(x: -8, y: -6), Point(x: -9, y: -7), Point(x: -10, y: -8)])
    }
    
    func testVerticalLineDrawing() {
        //test for drawing a vertical line in both directions
        XCTAssertEqual(pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: 0, y: 3)),
                       [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 3, y: 0)])
        
        XCTAssertEqual(pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: 0, y: -3)),
                       [Point(x: 0, y: 0), Point(x: -1, y: 0), Point(x: -2, y: 0), Point(x: -3, y: 0)])
        
        XCTAssertNotEqual(pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: 0, y: 0)),
                          [Point]())
    }

    func testHorizontalLineDrawing() {
        //test for drawing a horizontal line in both directions
        XCTAssertEqual(pointsForHorizontalLine(from: Point(x: 0, y: 0), to: Point(x: 3, y: 0)),
                       [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 3, y: 0)])
        
        XCTAssertEqual(pointsForHorizontalLine(from: Point(x: 0, y: 0), to: Point(x: -3, y: 0)),
                       [Point(x: 0, y: 0), Point(x: -1, y: 0), Point(x: -2, y: 0), Point(x: -3, y: 0)])
        
        XCTAssertNotEqual(pointsForHorizontalLine(from: Point(x: 0, y: 0), to: Point(x: 0, y: 0)),
                          [Point]())
        
    }
    
    func testEllipseDrawing() {
        
        let myEllipse = Ellipse(at: Point(x: 0, y: 0), height: 6, width: 4)
        XCTAssertEqual(myEllipse.generatePointsForDrawing(),
                       [Point(x: 0, y: 3), Point(x: 4, y: 3), Point(x: 1, y: 4), Point(x: 1, y: 2),
                        Point(x: 3, y: 4), Point(x: 3, y: 2), Point(x: 1, y: 5), Point(x: 1, y: 1),
                        Point(x: 3, y: 5), Point(x: 3, y: 1), Point(x: 2, y: 6), Point(x: 2, y: 0),
                        Point(x: 2, y: 6), Point(x: 2, y: 0)])
        
    }
    
    func testTriangleDrawing() {
        
        let myTriangle = Triangle(at: Point(x: 0, y: 0), corner1: Point(x: 0, y: 0), corner2: Point(x: 5, y: 0), corner3: Point(x: 0, y: -5))
        XCTAssertEqual(myTriangle.generatePointsForDrawing(),
                       [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 3, y: 0),
                        Point(x: 4, y: 0), Point(x: 5, y: 0), Point(x: 5, y: 0), Point(x: 4, y: -1),
                        Point(x: 3, y: -2), Point(x: 2, y: -3), Point(x: 1, y: -4), Point(x: 0, y: -5),
                        Point(x: 0, y: 0), Point(x: -1, y: 0), Point(x: -2, y: 0), Point(x: -3, y: 0),
                        Point(x: -4, y: 0), Point(x: -5, y: 0)])
    }
    
    func testTextDrawing() {
        let myDrawing = Text("example of text drawing! 123", font: "/Library/Fonts/Arial.ttf", at: Point(x: 0, y: 0))
        myDrawing.generatePointsForDrawing()
    }
    
    static var allTests = [
        ("testLineDrawing", testObliqueLineDrawing),
    ]
}

