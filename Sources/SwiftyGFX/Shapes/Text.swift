//
//  Text.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation
import CFreeType

fileprivate extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}


public struct Text: Drawable {
    public var origin: Point
    public var text: String
    private var library: FT_Library?
    private var face: FT_Face?
    
    private func getDefaultFontPath() -> String {
        
        let defaultPathForRaspbian = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
        guard FileManager.default.fileExists(atPath: defaultPathForRaspbian) else {
            let task = Process()
            if #available(OSX 10.13, *) {
                task.executableURL = URL(fileURLWithPath: "/bin/sh")
            } else {
                task.launchPath = "/bin/sh"
            }
            task.arguments = ["-c", "fc-list"]
            let outputPipe = Pipe()
            task.standardOutput = outputPipe
            
            if #available(OSX 10.13, *) {
                try? task.run()
            } else {
                task.launch()
            }
            let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: data, as: UTF8.self)
            
            guard let pathToFirstFoundFont = output.components(separatedBy: "\n").first?.matchingStrings(regex: "^(\\/[^\\/ ]*)+\\/([^:]*)?").first?.first else {
                fatalError("Can not determin default font, please specify one!")
            }
            return pathToFirstFoundFont
        }
        return defaultPathForRaspbian
    }
    
    public init(_ text: String, font pathToFont: String? = nil, at origin: Point = Point(x: 0, y: 0), pixelHeight: UInt32 = 16, pixelWidth: UInt32 = 16) {
        self.origin = origin
        self.text = text
        
        guard FT_Init_FreeType(&library) == FT_Err_Ok else {
            fatalError("Error during initialization! Error occured during initialization of the freetype library!")
        }
        
        guard FT_New_Face(library, pathToFont == nil ? getDefaultFontPath() : pathToFont, 0, &face) == FT_Err_Ok else {
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
    
    public func rendered() -> [(Int, Int)] {
        var result = [Point]()
        
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
                                result.append(Point(x: Int(x)*8+Int(7-power) +  adjustedOffset,
                                                    y: Int(y)+Int(downOffset)))
                            }
                            power += 1
                        }
                    }
                }
                previousGlyphIndex = glyphIndex
                summaryLeftOffset += UInt32(face!.pointee.glyph.pointee.metrics.horiAdvance) >> 6
            }
        }
        return result.movedTo(origin).convertedToCoordinates()
    }
    
    
}
