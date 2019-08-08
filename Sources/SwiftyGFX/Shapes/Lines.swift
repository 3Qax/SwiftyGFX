//
//  Lines.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct ObliqueLine: Drawable {
    public var origin: Point
    public var endPoint: Point
    
    init(from origin: Point, to endPoint: Point) {
        self.endPoint = endPoint
        self.origin = origin
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForLine(from: origin, to: endPoint).convertedToCoordinates()
    }
    
}
public struct HorizontalLine: Drawable {
    
    public var origin: Point
    public var endPoint: Point
    
    init(from origin: Point, to endPoint: Point) {
        self.origin = origin
        self.endPoint = endPoint
    }
    
    init(from origin: Point, lenght: UInt) {
        self.origin = origin
        self.endPoint = Point(x: origin.x+Int(lenght), y: origin.y)
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForHorizontalLine(from: origin, to: Point(x: endPoint.x, y: origin.y)).convertedToCoordinates()
    }
    
}
public struct VerticalLine: Drawable {
    
    public var origin: Point
    public var endPoint: Point
    
    init(from origin: Point, to endPoint: Point) {
        self.origin = origin
        self.endPoint = endPoint
    }
    
    init(from origin: Point, lenght: UInt) {
        self.origin = origin
        self.endPoint = Point(x: origin.x, y: origin.y+Int(lenght))
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForVerticalLine(from: origin, to: Point(x: origin.x, y: endPoint.y)).convertedToCoordinates()
    }
    
}
