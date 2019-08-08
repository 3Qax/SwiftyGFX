//
//  Circle.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Circle: Drawable, Fillable {
    
    public var origin: Point
    public private(set) var isFilled = false
    public var radius: UInt
    
    init(at origin: Point = Point(x: 0, y: 0), radius: UInt) {
        self.origin = origin
        self.radius = radius
    }
    
    init(at origin: Point = Point(x: 0, y: 0), width: UInt) {
        self.origin = origin
        self.radius = width/2
    }
    
    mutating public func fill() {
        self.isFilled = true
    }
    
    public func filled() -> Circle {
        var result = self
        result.isFilled = true
        return result
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [Point]()
        
        switch isFilled {
        case true:
            
            for x in stride(from: -Int(radius), through: Int(radius), by: 1) {
                result.append(Point(x: x + Int(radius), y: Int(radius)))
            }
            
            var x0 = Int(radius)
            var dx = 0
            
            // now do both halves at the same time, away from the diameter
            for y in stride(from: 1, through: Int(radius), by: 1) {
                var x1 = x0 - (dx - 1);  // try slopes of dx - 1 or more
                
                while x1 > 0 {
                    if x1*x1*Int(radius)*Int(radius) + y*y*Int(radius)*Int(radius) <= Int(radius)*Int(radius)*Int(radius)*Int(radius) { break }
                    x1 -= 1
                }
                
                dx = x0 - x1;  // current approximation of the slope
                x0 = x1;
                
                for x in stride(from: -x0, through: x0, by: 1) {
                    result.append(Point(x: x + Int(radius), y: -y + Int(radius)))
                    result.append(Point(x: x + Int(radius), y: y + Int(radius)))
                }
                
            }
        case false:
            
            result.append(Point(x: 0, y: Int(radius)))
            result.append(Point(x: 2 * Int(radius), y: Int(radius)))
            
            var x0 = Int(radius)
            var dx = 0
            
            // now do both halves at the same time, away from the diameter
            for y in stride(from: 1, through: Int(radius), by: 1) {
                var x1 = x0 - (dx - 1);  // try slopes of dx - 1 or more
                
                while x1 > 0 {
                    if x1*x1*Int(radius)*Int(radius) + y*y*Int(radius)*Int(radius) <= Int(radius)*Int(radius)*Int(radius)*Int(radius) { break }
                    x1 -= 1
                }
                
                dx = x0 - x1;  // current approximation of the slope
                x0 = x1;
                
                result.append(Point(x: -x0 + Int(radius),y: y + Int(radius)))
                result.append(Point(x: -x0 + Int(radius),y: -y + Int(radius)))
                result.append(Point(x: x0 + Int(radius),y: y + Int(radius)))
                result.append(Point(x: x0 + Int(radius),y: -y + Int(radius)))
            }
        }
        return result.movedTo(origin).convertedToCoordinates()
    }
    
}
