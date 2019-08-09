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
    
    public func rendered() -> [(Int, Int)] {
        var result = [(Int, Int)]()
        
        switch isFilled {
        case true:
            for i in origin.y...origin.y+Int(sideSize) {
                result.append(contentsOf: Line(from: Point(x: origin.x, y: i),
                                               to: Point(x: origin.x+Int(sideSize), y: i))
                                            .rendered())
            }
        case false:
            //top
            result.append(contentsOf: Line(from: origin,
                                           to: Point(x: origin.x+Int(sideSize), y: origin.y))
                                        .rendered())
            //right
            result.append(contentsOf: Line(from: Point(x: origin.x+Int(sideSize), y: origin.y),
                                           to: Point(x: origin.x+Int(sideSize), y: origin.y+Int(sideSize)))
                                        .rendered())
            //bottom
            result.append(contentsOf: Line(from: Point(x: origin.x+Int(sideSize), y: origin.y+Int(sideSize)),
                                           to: Point(x: origin.x, y: origin.y+Int(sideSize)))
                                        .rendered())
            //left
            result.append(contentsOf: Line(from: Point(x: origin.x, y: origin.y+Int(sideSize)),
                                           to: origin)
                                        .rendered())
        }
        
        return result
    }
    
}
