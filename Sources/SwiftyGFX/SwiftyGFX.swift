public struct Point: Equatable {
    var x: Int
    var y: Int
    
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public protocol Drawable {
    var origin: Point { get set }
    
    func generatePointsForDrawing() -> [Point]
}

//Using Bresenham's line algorithm
func pointsForLine(from p1: Point, to p2: Point) -> [Point] {
    
    guard p1.x != p2.x && p1.y != p2.y else {
        return [p1]
    }
    
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

func pointsForVerticalLine(from p1: Point, to p2: Point) -> [Point] {
    
    guard p1.y != p2.y else {
        return [p1]
    }
    
    var result = [Point]()
    
    for y in stride(from: p1.y, through: p2.y, by: p1.y > p2.y ? -1 : 1) {
        result.append(Point(x: y, y: p1.y))
    }
    
    return result
    
}

func pointsForHorizontalLine(from p1: Point, to p2: Point) -> [Point] {
    
    guard p1.x != p2.x else {
        return [p1]
    }
    
    var result = [Point]()
    
    for x in stride(from: p1.x, through: p2.x, by: p1.x > p2.x ? -1 : 1) {
        result.append(Point(x: x, y: p1.y))
    }
    
    return result
    
}

public class ObliqueLine: Drawable {
    
    public var origin: Point
    public var endPoint: Point
    
    init(from origin: Point, to endPoint: Point) {
        self.endPoint = endPoint
        self.origin = origin
    }
    
    public func generatePointsForDrawing() -> [Point] {
        return pointsForLine(from: origin, to: endPoint)
    }
    
}
public class HorizontalLine: ObliqueLine {
    
    convenience init(from origin: Point, lenght: Int) {
        self.init(from: origin, to: Point(x: origin.x + lenght, y: origin.y))
    }
    
    override public func generatePointsForDrawing() -> [Point] {
        return pointsForHorizontalLine(from: origin, to: endPoint)
    }
    
}
public class VerticalLine: ObliqueLine {
    
    convenience init(from origin: Point, lenght: Int) {
        self.init(from: origin, to: Point(x: origin.x, y: origin.y + lenght))
    }
    
    override public func generatePointsForDrawing() -> [Point] {
        return pointsForVerticalLine(from: origin, to: endPoint)
    }
    
}

public class Rectangle: Drawable {

    public var origin: Point
    public var width: Int {
        willSet {
            guard newValue > 0 else {
                fatalError("Width have to be greater than 0!")
            }
        }
    }
    public var height: Int {
        willSet {
            guard newValue > 0 else {
                fatalError("Height have to be greater than 0!")
            }
        }
    }
    
    init(at origin: Point, height: Int, width: Int) {
        self.origin = origin
        self.height = height
        self.width = width
    }
    
    public func generatePointsForDrawing() -> [Point] {
        var result = [Point]()
        result.append(contentsOf: pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: width, y: 0)))
        result.append(contentsOf: pointsForHorizontalLine(from: Point(x: width, y: 0), to: Point(x: width, y: height)))
        result.append(contentsOf: pointsForVerticalLine(from: Point(x: width, y: height), to: Point(x: 0, y: width)))
        result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: width), to: Point(x: 0, y: 0)))
        return result
    }

}
public class Square: Rectangle {
    init(at origin: Point, sideSize a: Int) {
        super.init(at: origin, height: a, width: a)
    }
}

public class Ellipse: Drawable {
    public var origin: Point
    public var yRadius: Int {
        willSet {
            guard newValue > 0 else {
                fatalError("Y radius can not be smaller then or equal to zero")
            }
        }
    }
    public var xRadius: Int {
        willSet {
            guard newValue > 0 else {
                fatalError("X radius can not be smaller then or equal to zero")
            }
        }
    }
    
    init(at origin: Point, yRadius: Int, xRadius: Int) {
        self.origin = origin
        self.yRadius = yRadius
        self.xRadius = xRadius
    }

    init(at origin: Point, height: Int, width: Int) {
        self.origin = origin
        self.yRadius = height/2
        self.xRadius = width/2
    }
    
    public func generatePointsForDrawing() -> [Point] {
        
        var result = [Point]()
        
        //for filled version
        // do the horizontal diameter
//        for x in stride(from: -xRadius, through: xRadius, by: 1) {
//            result.append(Point(x: x + xRadius, y: yRadius))
//        }
        
        result.append(Point(x: 0, y: yRadius))
        result.append(Point(x: 2 * xRadius, y: yRadius))
        
        var x0 = xRadius
        var dx = 0
        
        // now do both halves at the same time, away from the diameter
        for y in stride(from: 1, through: yRadius, by: 1) {
            var x1 = x0 - (dx - 1);  // try slopes of dx - 1 or more
            
            while x1 > 0 {
                if x1*x1*yRadius*yRadius + y*y*xRadius*xRadius <= yRadius*yRadius*xRadius*xRadius { break }
                x1 -= 1
            }
           
            dx = x0 - x1;  // current approximation of the slope
            x0 = x1;
            
            //for filled version
//            for x in stride(from: -x0, through: x0, by: 1) {
//                result.append(Point(x: x + xRadius, y: -y + yRadius))
//                result.append(Point(x: x + xRadius, y: y + yRadius))
//            }
            
            result.append(Point(x: -x0 + xRadius, y: y + yRadius))
            result.append(Point(x: -x0 + xRadius, y: -y + yRadius))
            result.append(Point(x: x0 + xRadius, y: y + yRadius))
            result.append(Point(x: x0 + xRadius, y: -y + yRadius))
            
        }
        result.forEach({ print("\($0.x) \($0.y)")})
        return result
    }
    
}
public class Circle: Ellipse {
    
    init(at origin: Point, radius: Int) {
        super.init(at: origin, yRadius: radius, xRadius: radius)
    }
    
    init(at origin: Point, width: Int) {
        super.init(at: origin, yRadius: width/2, xRadius: width/2)
    }
    
}

public class Triangle: Drawable {
    public var origin: Point
    public var p1: Point
    public var p2: Point
    public var p3: Point
    
    init(at origin: Point, corner1: Point, corner2: Point, corner3: Point) {
        self.origin = origin
        self.p1 = corner1
        self.p2 = corner2
        self.p3 = corner3
    }

    public func generatePointsForDrawing() -> [Point] {
        
        var result = [Point]()
        
        if (p1.x == p2.x) {
            result.append(contentsOf: pointsForVerticalLine(from: p1, to: p2))
        } else if (p1.y == p2.y) {
            result.append(contentsOf: pointsForHorizontalLine(from: p1, to: p2))
        } else {
            result.append(contentsOf: pointsForLine(from: p1, to: p2))
        }
        
        if (p2.x == p3.x) {
            result.append(contentsOf: pointsForVerticalLine(from: p2, to: p3))
        } else if (p2.y == p3.y) {
            result.append(contentsOf: pointsForHorizontalLine(from: p2, to: p3))
        } else {
            result.append(contentsOf: pointsForLine(from: p2, to: p3))
        }
        
        if (p1.x == p3.x) {
            result.append(contentsOf: pointsForVerticalLine(from: p1, to: p3))
        } else if (p1.y == p3.y) {
            result.append(contentsOf: pointsForHorizontalLine(from: p1, to: p3))
        } else {
            result.append(contentsOf: pointsForLine(from: p1, to: p3))
        }
        
        return result
    }

}
