//
//  Ellipse.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Ellipse: Drawable, Fillable {
    
    public var origin: Point
    public private(set) var isFilled = false
    public var yRadius: UInt
    public var xRadius: UInt
    
    init(at origin: Point = Point(x: 0, y: 0), yRadius: UInt, xRadius: UInt) {
        self.origin = origin
        self.yRadius = yRadius
        self.xRadius = xRadius
    }
    
    init(at origin: Point = Point(x: 0, y: 0), height: UInt, width: UInt) {
        self.origin = origin
        self.yRadius = height/2
        self.xRadius = width/2
    }
    
    mutating public func fill() {
        self.isFilled = true
    }
    
    public func filled() -> Ellipse {
        var result = self
        result.isFilled = true
        return result
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [Point]()
        
        switch isFilled {
        case true:
            
            for x in stride(from: -Int(xRadius), through: Int(xRadius), by: 1) {
                result.append(Point(x: x + Int(xRadius), y: Int(yRadius)))
            }
            
            var x0 = Int(xRadius)
            var dx = 0
            
            // now do both halves at the same time, away from the diameter
            for y in stride(from: 1, through: Int(yRadius), by: 1) {
                var x1 = x0 - (dx - 1);  // try slopes of dx - 1 or more
                
                while x1 > 0 {
                    if x1*x1*Int(yRadius)*Int(yRadius) + y*y*Int(xRadius)*Int(xRadius) <= Int(yRadius)*Int(yRadius)*Int(xRadius)*Int(xRadius) { break }
                    x1 -= 1
                }
                
                dx = x0 - x1;  // current approximation of the slope
                x0 = x1;
                
                for x in stride(from: -x0, through: x0, by: 1) {
                    result.append(Point(x: x + Int(xRadius), y: -y + Int(yRadius)))
                    result.append(Point(x: x + Int(xRadius), y: y + Int(yRadius)))
                }
                
            }
        case false:
            
            result.append(Point(x: 0, y: Int(yRadius)))
            result.append(Point(x: 2 * Int(xRadius), y: Int(yRadius)))
            
            var x0 = Int(xRadius)
            var dx = 0
            
            // now do both halves at the same time, away from the diameter
            for y in stride(from: 1, through: Int(yRadius), by: 1) {
                var x1 = x0 - (dx - 1);  // try slopes of dx - 1 or more
                
                while x1 > 0 {
                    if x1*x1*Int(yRadius)*Int(yRadius) + y*y*Int(xRadius)*Int(xRadius) <= Int(yRadius)*Int(yRadius)*Int(xRadius)*Int(xRadius) { break }
                    x1 -= 1
                }
                
                dx = x0 - x1;  // current approximation of the slope
                x0 = x1;
                
                result.append(Point(x: -x0 + Int(xRadius), y: y + Int(yRadius)))
                result.append(Point(x: -x0 + Int(xRadius), y: -y + Int(yRadius)))
                result.append(Point(x: x0 + Int(xRadius), y: y + Int(yRadius)))
                result.append(Point(x: x0 + Int(xRadius), y: -y + Int(yRadius)))
            }
        }
        return result.movedTo(origin).convertedToCoordinates()
    }
    
}
