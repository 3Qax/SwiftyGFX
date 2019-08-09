//
//  Triangle.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Triangle: Drawable, Fillable {
    
    public var origin: Point
    public var p1: Point
    public var p2: Point
    public var p3: Point
    public private(set) var isFilled = false
    
    init(at origin: Point = Point(x: 0, y: 0), corner1: Point, corner2: Point, corner3: Point) {
        self.origin = origin
        self.p1 = corner1
        self.p2 = corner2
        self.p3 = corner3
    }
    
    mutating public func fill() {
        self.isFilled = true
    }
    
    public func filled() -> Triangle {
        var result = self
        result.isFilled = true
        return result
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [Point]()
        
        switch isFilled {
        case true:
            
            let boundingBoxHeight = max(abs(p2.y-p1.y), abs(p3.y-p2.y), abs(p1.y-p3.y))
            var buff_x0 = Array<Int>()
            var buff_x1 = Array<Int>()
            
            let linesPoints = [(p1, p2), (p2, p3), (p3, p1)]
            for (start, end) in linesPoints {
                let Δy = end.y - start.y
                if Δy < 0 {
                    (start.x == end.x ? pointsForVerticalLine(from: start, to: end).dropFirst() : pointsForObliqueLine(from: start, to: end).dropFirst())
                        .forEach({
                            buff_x0.append($0.x)
                        })
                } else if Δy > 0 {
                    (start.x == end.x ? pointsForVerticalLine(from: start, to: end).dropFirst() : pointsForObliqueLine(from: start, to: end).dropFirst())
                        .forEach({
                            buff_x1.append($0.x)
                        })
                } else { // Δy == 0
                    buff_x0.append(start.x)
                    buff_x1.append(end.x)
                }
            }
            
            for y in 0..<boundingBoxHeight {
                result.append(contentsOf: pointsForHorizontalLine(from: Point(x: buff_x0[y], y: y),
                                                                  to: Point(x: buff_x1[y], y: y)))
            }
            
            result.append(p1)
            result.append(p2)
            result.append(p3)
        case false:
            if (p1.x == p2.x) {
                result.append(contentsOf: pointsForVerticalLine(from: p1, to: p2))
            } else if (p1.y == p2.y) {
                result.append(contentsOf: pointsForHorizontalLine(from: p1, to: p2))
            } else {
                result.append(contentsOf: pointsForObliqueLine(from: p1, to: p2))
            }
            
            if (p2.x == p3.x) {
                result.append(contentsOf: pointsForVerticalLine(from: p2, to: p3))
            } else if (p2.y == p3.y) {
                result.append(contentsOf: pointsForHorizontalLine(from: p2, to: p3))
            } else {
                result.append(contentsOf: pointsForObliqueLine(from: p2, to: p3))
            }
            
            if (p1.x == p3.x) {
                result.append(contentsOf: pointsForVerticalLine(from: p1, to: p3))
            } else if (p1.y == p3.y) {
                result.append(contentsOf: pointsForHorizontalLine(from: p1, to: p3))
            } else {
                result.append(contentsOf: pointsForObliqueLine(from: p1, to: p3))
            }
        }
        
        return result.movedTo(origin).convertedToCoordinates()
        
    }
    
}
