//
//  Square.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Square: Drawable, Fillable {
    
    public var origin: Point
    public private(set) var isFilled = false
    public var sideSize: UInt
    
    
    init(at origin: Point = Point(x: 0, y: 0), sideSize a: UInt) {
        self.origin = origin
        self.sideSize = a
    }
    
    mutating public func fill() {
        self.isFilled = true
    }
    
    public func filled() -> Square {
        var result = self
        result.isFilled = true
        return self
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        var result = [Point]()
        
        switch isFilled {
        case true:
            for i in 0...Int(sideSize)-1 {
                result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: i), to: Point(x: Int(sideSize)-1, y: i)))
            }
        case false:
            result.append(contentsOf: pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: Int(sideSize), y: 0)))
            result.append(contentsOf: pointsForHorizontalLine(from: Point(x: Int(sideSize), y: 0), to: Point(x: Int(sideSize), y: Int(sideSize))))
            result.append(contentsOf: pointsForVerticalLine(from: Point(x: Int(sideSize), y: Int(sideSize)), to: Point(x: 0, y: Int(sideSize))))
            result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: Int(sideSize)), to: Point(x: 0, y: 0)))
        }
        
        return result.movedTo(origin).convertedToCoordinates()
    }
    
}
