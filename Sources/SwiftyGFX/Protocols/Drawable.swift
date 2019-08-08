//
//  Drawable.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public protocol Drawable {
    var origin: Point { get set }
    func generatePointsForDrawing() -> [(Int, Int)]
}
