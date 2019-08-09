//
//  Rectangle.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Rectangle: Drawable, Fillable {
    public var origin: Point
    public var width: UInt
    public var height: UInt
    public private(set) var isFilled = false
    
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
    
    public func rendered() -> [(Int, Int)] {
        var result = [(Int, Int)]()
        
        switch isFilled {
        case true:
            for i in 0...Int(height)-1 {
                result.append(contentsOf: Line(from: Point(x: 0, y: i),
                                               to: Point(x: Int(width)-1, y: i))
                                            .rendered())
            }
        case false:
            // top
            result.append(contentsOf: Line(from: origin,
                                           to: Point(x: origin.x+Int(width), y: origin.y))
                                        .rendered())
            // right
            result.append(contentsOf: Line(from: Point(x: origin.x+Int(width), y: origin.y),
                                           to: Point(x: origin.x+Int(width), y: origin.y+Int(height)))
                                        .rendered())
            // bottom
            result.append(contentsOf: Line(from: Point(x: origin.x+Int(width), y: origin.y+Int(height)),
                                           to: Point(x: origin.x, y: origin.y+Int(height)))
                                        .rendered())
            // left
            result.append(contentsOf: Line(from: Point(x: origin.x, y: origin.y+Int(height)),
                                           to: origin)
                                        .rendered())
        }
        
        return result
    }
    
}
