//
//  Line.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

internal enum LineType {
    case oblique
    case horizontal
    case vertical
}

public struct Line: Drawable {
    public var origin: Point
    public var endPoint: Point
    internal let type: LineType
    
    init(from origin: Point, to endPoint: Point) {
        self.endPoint = endPoint
        self.origin = origin
        
        guard origin != endPoint else {
            fatalError("""
                Attempted to create Line with length equal to 0!
                Line requires two diffrent points, but equal points (with equal coordinates) were used.
                If you meant to draw a single point use a Point type instead.
            """)
        }
        
        // Figure out line type
        if origin.x == endPoint.x { self.type = .vertical }
        else if origin.y == endPoint.y { self.type = .horizontal }
        else { self.type = .oblique }
        
    }
    
    init(from origin: Point, width: UInt) {
        guard width != 0 else { fatalError("Width of a Line have to be greater than 0!") }
        
        self.init(from: origin,
                  to: Point(x: origin.x+Int(width), y: origin.y))
    }
    
    init(from origin: Point, height: UInt) {
        guard height != 0 else { fatalError("Height of a Line have to be greater than 0!") }
        
        self.init(from: origin,
                  to: Point(x: origin.x, y: origin.y+Int(height)))
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        switch self.type {
        case .oblique:
            return pointsForObliqueLine(from: origin, to: endPoint).convertedToCoordinates()
        case .horizontal:
            return pointsForHorizontalLine(from: origin, to: Point(x: endPoint.x, y: origin.y)).convertedToCoordinates()
        case .vertical:
            return pointsForVerticalLine(from: origin, to: Point(x: origin.x, y: endPoint.y)).convertedToCoordinates()
        }
    }
}
