//
//  MultiplicationEntry.swift
//  vko2
//
//  Created by Tomi Heino on 14/01/2018.
//  Copyright © 2018 Tomi Heino. All rights reserved.
//

import Foundation

class MultiplicationEntry {
    var first: Int
    var second: Int
    
    init() {
        self.first = Int(arc4random_uniform(9) + 1)
        self.second = Int(arc4random_uniform(9) + 1)
    }
    
    func result() -> Int {
        return first * second
    }
    
    func description() -> String {
        return "\(String(first)) x \(String(second))"
    }
}
