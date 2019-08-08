//
//  Fillable.swift
//  SwiftyGFX
//
//  Created by Jakub Towarek on 08/08/2019.
//

import Foundation

public protocol Fillable {
    associatedtype T
    mutating func fill()
    func filled() -> T
}
