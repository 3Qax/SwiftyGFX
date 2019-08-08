import Foundation
#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif

//Using Bresenham's line algorithm
internal func pointsForLine(from p1: Point, to p2: Point) -> [Point] {
    
    guard p1.x != p2.x && p1.y != p2.y else { return [p1] }
    
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

internal func pointsForVerticalLine(from p1: Point, to p2: Point) -> [Point] {
    
    var result = [Point]()
    result.reserveCapacity(abs(p2.y-p1.y))
    
    for y in stride(from: p1.y, through: p2.y, by: p1.y > p2.y ? -1 : 1) {
        result.append(Point(x: p1.x, y: y))
    }
    
    return result
    
}

internal func pointsForHorizontalLine(from p1: Point, to p2: Point) -> [Point] {
    
    var result = [Point]()
    result.reserveCapacity(abs(p2.x-p1.x))
    
    for x in stride(from: p1.x, through: p2.x, by: p1.x > p2.x ? -1 : 1) {
        result.append(Point(x: x, y: p1.y))
    }
    
    return result
    
}
