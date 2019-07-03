import CFreeType
#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif


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
    
}

public protocol Drawable {
    func generatePointsForDrawing() -> [(Int, Int)]
}

//Using Bresenham's line algorithm
func pointsForLine(from p1: Point, to p2: Point) -> [(Int, Int)] {
    
    guard p1.x != p2.x && p1.y != p2.y else {
        return [(p1.x, p1.y)]
    }
    
    let Δx = p1.x - p2.x
    let Δy = p1.y - p2.y
    
    //α to nachylenie
    let αx = Δx < 0 ? 1 : -1
    let αy = Δy < 0 ? 1 : -1
    
    var result = [(Int, Int)]()
    
    if abs(Δy) < abs(Δx) {
        let α = Double(Δy) / Double(Δx)
        let pitch = Double(p1.y) - α * Double(p1.x) //to wysokość
        var p1 = p1
        while p1.x != p2.x {
            result.append((p1.x, Int((α * Double(p1.x) + pitch).rounded())))
            p1.x += αx
        }
    } else {
        let α = Double(Δx) / Double(Δy)
        let pitch = Double(p1.x) - α * Double(p1.y)
        var p1 = p1
        while p1.y != p2.y {
            result.append((Int((α * Double(p1.y) + pitch).rounded()), p1.y))
            p1.y += αy
        }
    }
    
    result.append((p2.x, p2.y))
    return result
}

func pointsForVerticalLine(from p1: Point, to p2: Point) -> [(Int, Int)] {
    
    guard p1.y != p2.y else {
        return [(p1.x, p1.y)]
    }
    
    var result = [(Int, Int)]()
    
    for y in stride(from: p1.y, through: p2.y, by: p1.y > p2.y ? -1 : 1) {
        result.append((y, p1.y))
    }
    
    return result
    
}

func pointsForHorizontalLine(from p1: Point, to p2: Point) -> [(Int, Int)] {
    
    guard p1.x != p2.x else {
        return [(p1.x, p1.y)]
    }
    
    var result = [(Int, Int)]()
    
    for x in stride(from: p1.x, through: p2.x, by: p1.x > p2.x ? -1 : 1) {
        result.append((x, p1.y))
    }
    
    return result
    
}

fileprivate extension Array where Element == (Int, Int) {
    func movedTo(_ point: Point) -> [(Int, Int)] {
        return self.map({ return ($0.0+point.x, $0.1+point.y)})
    }
}

//Lines
public class ObliqueLine: Drawable {
    public var origin: Point
    public var endPoint: Point
    
    init(from origin: Point, to endPoint: Point) {
        self.endPoint = endPoint
        self.origin = origin
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForLine(from: origin, to: endPoint)
    }
    
}
public class HorizontalLine: ObliqueLine {
    
    convenience init(from origin: Point, lenght: Int) {
        self.init(from: origin, to: Point(x: origin.x + lenght, y: origin.y))
    }
    
    override public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForHorizontalLine(from: origin, to: endPoint)
    }
    
}
public class VerticalLine: ObliqueLine {
    
    convenience init(from origin: Point, lenght: Int) {
        self.init(from: origin, to: Point(x: origin.x, y: origin.y + lenght))
    }
    
    override public func generatePointsForDrawing() -> [(Int, Int)] {
        return pointsForVerticalLine(from: origin, to: endPoint)
    }
    
}

//Rectangles
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
    
    init(at origin: Point = Point(x: 0, y: 0), height: Int, width: Int) {
        self.origin = origin
        self.height = height
        self.width = width
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        var result = [(Int, Int)]()
        result.append(contentsOf: pointsForVerticalLine(from: Point(x: 0, y: 0), to: Point(x: width, y: 0)))
        result.append(contentsOf: pointsForHorizontalLine(from: Point(x: width, y: 0), to: Point(x: width, y: height)))
        result.append(contentsOf: pointsForVerticalLine(from: Point(x: width, y: height), to: Point(x: 0, y: width)))
        result.append(contentsOf: pointsForHorizontalLine(from: Point(x: 0, y: width), to: Point(x: 0, y: 0)))
        return result.movedTo(origin)
    }

}
public class Square: Rectangle {
    init(at origin: Point = Point(x: 0, y: 0), sideSize a: Int) {
        super.init(at: origin, height: a, width: a)
    }
}

//Ellipses
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
    
    init(at origin: Point = Point(x: 0, y: 0), yRadius: Int, xRadius: Int) {
        self.origin = origin
        self.yRadius = yRadius
        self.xRadius = xRadius
    }

    init(at origin: Point = Point(x: 0, y: 0), height: Int, width: Int) {
        self.origin = origin
        self.yRadius = height/2
        self.xRadius = width/2
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [(Int, Int)]()
        
        //for filled version
        // do the horizontal diameter
//        for x in stride(from: -xRadius, through: xRadius, by: 1) {
//            result.append(Point(x: x + xRadius, y: yRadius))
//        }
        
        result.append((0, yRadius))
        result.append((2 * xRadius, yRadius))
        
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
            
            result.append((-x0 + xRadius, y + yRadius))
            result.append((-x0 + xRadius, -y + yRadius))
            result.append((x0 + xRadius, y + yRadius))
            result.append((x0 + xRadius, -y + yRadius))
            
        }
        return result.movedTo(origin)
    }
    
}
public class Circle: Ellipse {
    
    init(at origin: Point = Point(x: 0, y: 0), radius: Int) {
        super.init(at: origin, yRadius: radius, xRadius: radius)
    }
    
    init(at origin: Point = Point(x: 0, y: 0), width: Int) {
        super.init(at: origin, yRadius: width/2, xRadius: width/2)
    }
    
}

//Traingels
public class Triangle: Drawable {
    public var origin: Point
    public var p1: Point
    public var p2: Point
    public var p3: Point
    
    init(at origin: Point = Point(x: 0, y: 0), corner1: Point, corner2: Point, corner3: Point) {
        self.origin = origin
        self.p1 = corner1
        self.p2 = corner2
        self.p3 = corner3
    }

    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [(Int, Int)]()
        
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
        
        return result.movedTo(origin)
    }

}

//Text
public class Text: Drawable {
    public var origin: Point
    public var text: String
    private var library: FT_Library?
    private var face: FT_Face?
    
    public init(_ text: String, font pathToFont: String, at origin: Point = Point(x: 0, y: 0), pixelHeight: UInt32 = 16, pixelWidth: UInt32 = 16) {
        self.origin = origin
        self.text = text
        
        guard FT_Init_FreeType(&library) == FT_Err_Ok else {
            fatalError("Error during initialization! Error occured during initialization of the freetype library!")
        }
        
        // "/Library/Fonts/Arial.ttf"
        guard FT_New_Face(library, pathToFont, 0, &face) == FT_Err_Ok else {
            fatalError("Error during initialization! Please make sure that given path is valid and used file format of font is supported!")
        }
        
        guard FT_Set_Pixel_Sizes(&face!.pointee, pixelHeight, pixelWidth) == FT_Err_Ok else {
            fatalError("Error during initialization! Can not set char pixel for a choosen face!")
        }
        
    }
    
    public func setChar(height: Int, width: Int, horizontalResolution: UInt32, verticalResolution: UInt32) {
        guard FT_Set_Char_Size(&face!.pointee, height, width, horizontalResolution, verticalResolution) == FT_Err_Ok else {
            fatalError("Can not set char size!")
        }
    }
    
    public func setPixel(height: UInt32, width: UInt32) {
        guard FT_Set_Pixel_Sizes(&face!.pointee, height, width) == FT_Err_Ok else {
            fatalError("Can not set pixel size!")
        }
    }
    
    public func generatePointsForDrawing() -> [(Int, Int)] {
        
        var result = [(Int, Int)]()
        
        
        var previousGlyphIndex: UInt32 = 0
        var summaryLeftOffset: UInt32 = 0
        for character in text {
            for scalar in character.unicodeScalars {
                
                let glyphIndex = FT_Get_Char_Index(face, FT_ULong(scalar.value))
                
                guard FT_Load_Glyph(face, glyphIndex, FT_Int32(FT_LOAD_MONOCHROME)) == FT_Err_Ok else {
                    fatalError()
                }
                
                guard FT_Render_Glyph(face?.pointee.glyph, FT_RENDER_MODE_MONO) == FT_Err_Ok else {
                    fatalError()
                }
                
                let bitmap = face!.pointee.glyph.pointee.bitmap
                
                //determin kerning offset
                var kerningDistanceVector = FT_Vector(x: 0, y: 0)
                FT_Get_Kerning(face, previousGlyphIndex, glyphIndex, FT_KERNING_DEFAULT.rawValue, &kerningDistanceVector)
                //print("Kerning: \(kerningDistanceVector.x)")
                
                //adjust summary offset
                let adjustedOffset = Int(summaryLeftOffset) + kerningDistanceVector.x
                
                //adjust down offset, which aligns glyphs along their baseline
                let downOffset = -(face!.pointee.glyph.pointee.metrics.horiBearingY >> 6) + (face!.pointee.size.pointee.metrics.ascender>>6)
                
                for y in 0..<bitmap.rows {
                    for x in 0..<bitmap.pitch {
                        let byte = bitmap.buffer![Int(y*UInt32(bitmap.pitch)+UInt32(x))]
                        var power: UInt8 = 0
                        while power < 8 {
                            let mask: UInt8 = UInt8(pow(2.0,Double(power)))
                            if byte & mask > 0 {
                                //print("Adding point for:\nbyte:\t\(String(byte, radix: 2))\nmask:\t\(String(mask, radix: 2))")
                                //result.append(Point(x: Int(x)*8+Int(7-power) +  adjustedOffset, y: Int(y)+Int(downOffset)))
                                result.append((Int(x)*8+Int(7-power) +  adjustedOffset, Int(y)+Int(downOffset)))
                            }
                            power += 1
                        }
                    }
                }
                previousGlyphIndex = glyphIndex
                summaryLeftOffset += UInt32(face!.pointee.glyph.pointee.metrics.horiAdvance) >> 6
            }
        }
        return result.movedTo(origin)
    }
    
    
}
