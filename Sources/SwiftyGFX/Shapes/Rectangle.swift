//
//  Rectangle.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Rectangle: Drawable, Fillable {
    
    public var origin: Point
    public private(set) var isFilled = false
    public var width: UInt
    public var height: UInt
    
    init(at origin: Point = Point(x: 0, y: 0), height: UInt, width: UInt) {
        self.origin = origin
        self.height = height
        self.width = width
    }
    
    mutating public func fill() {
        self.isFilled = true
    }
    
    public func filled() -> Rectangle {
        var result = self
        result.isFilled = true
        return self
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        var result = [Point]()
        
        switch isFilled {
        case true:
            for i in 0...Int(height)-1 {
                result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: i), to: Point(x: Int(width)-1, y: i)))
            }
        case false:
            result.append(contentsOf: pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: Int(width), y: 0)))
            result.append(contentsOf: pointsForHorizontalLine(from: Point(x: Int(width), y: 0), to: Point(x: Int(width), y: Int(height))))
            result.append(contentsOf: pointsForVerticalLine(from: Point(x: Int(width), y: Int(height)), to: Point(x: 0, y: Int(width))))
            result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: Int(width)), to: Point(x: 0, y: 0)))
        }
        
        return result.movedTo(origin).convertedToCoordinates()
    }
    
}
