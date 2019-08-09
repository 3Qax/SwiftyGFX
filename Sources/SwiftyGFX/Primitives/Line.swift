//
//  Line.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation
#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif

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
    
    public func rendered() -> [(Int, Int)] {
        switch self.type {
        case .oblique:
            return pointsForObliqueLine(from: origin, to: endPoint).convertedToCoordinates()
        case .horizontal:
            return pointsForHorizontalLine(from: origin, to: endPoint).convertedToCoordinates()
        case .vertical:
            return pointsForVerticalLine(from: origin, to: endPoint).convertedToCoordinates()
        }
    }
}

extension Line: Equatable {
    public static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.origin == rhs.origin && lhs.endPoint == rhs.endPoint
               || lhs.origin == rhs.endPoint && lhs.endPoint == rhs.origin
    }
}

// MARK: Line rendering functions
extension Line {
    
    private func pointsForObliqueLine(from p1: Point, to p2: Point) -> [Point] {
        // This function uses Bresenham's line algorithm
        
        let Δx = p1.x - p2.x
        let Δy = p1.y - p2.y
        
        //α to nachylenie
        let αx = Δx < 0 ? 1 : -1
        let αy = Δy < 0 ? 1 : -1
        
        var result = [Point]()
        
        if abs(Δy) < abs(Δx) {
            let α = Double(Δy) / Double(Δx)
            let pitch = Double(p1.y) - α * Double(p1.x) //to wysokość
            var p1 = p1
            while p1.x != p2.x {
                result.append(Point(x: p1.x, y: Int((α * Double(p1.x) + pitch).rounded())))
                p1.x += αx
            }
        } else {
            let α = Double(Δx) / Double(Δy)
            let pitch = Double(p1.x) - α * Double(p1.y)
            var p1 = p1
            while p1.y != p2.y {
                result.append(Point(x: Int((α * Double(p1.y) + pitch).rounded()), y: p1.y))
                p1.y += αy
            }
        }
        
        result.append(p2)
        return result
    }
    
    private func pointsForVerticalLine(from p1: Point, to p2: Point) -> [Point] {
        
        var result = [Point]()
        result.reserveCapacity(abs(p2.y-p1.y))
        
        for y in stride(from: p1.y, through: p2.y, by: p1.y > p2.y ? -1 : 1) {
            result.append(Point(x: p1.x, y: y))
        }
        
        return result
        
    }
    
    private func pointsForHorizontalLine(from p1: Point, to p2: Point) -> [Point] {
        
        var result = [Point]()
        result.reserveCapacity(abs(p2.x-p1.x))
        
        for x in stride(from: p1.x, through: p2.x, by: p1.x > p2.x ? -1 : 1) {
            result.append(Point(x: x, y: p1.y))
        }
        
        return result
        
    }
    
}
