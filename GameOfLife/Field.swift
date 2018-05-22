//
//  Field.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class Field: UIView {
    
    var cellsPerRow = 0
    var cellsPerColumn = 0
    
    // Key like "x|y"
    var cells = [String : Cell]()
}
