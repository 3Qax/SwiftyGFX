//
//  Point.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public struct Point: Equatable, CustomStringConvertible {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public var description: String {
        return "\(x)\t\(y)"
    }
    
    public var coordinates: (Int, Int) {
        return (x, y)
    }
    
}

internal extension Array where Element == Point {
    
    func movedTo(_ point: Point) -> [Point] {
        return self.map({ return Point(x: $0.x+point.x, y: $0.y+point.y)})
    }
    
    func convertedToCoordinates() -> [(Int, Int)] {
        return self.map({ $0.coordinates })
    }
}
