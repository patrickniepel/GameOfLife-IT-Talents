//
//  Generation.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 17.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class Generation: NSObject, NSCoding {
    
    var name : String = ""
    var boardSizeX : Int = 0
    var boardSizeY : Int = 0
    
    // Entries like "x|y"
    var positions : [String] = []
    
    private let nameKey = "name"
    private let boardSizeXKey = "boardSizeX"
    private let boardSizeYKey = "boardSizeY"
    private let positionsKey = "positions"
    
    override init() {}
    
    init(aName: String, sizeX: Int, sizeY: Int, tappedCells: [String]) {
        name = aName
        boardSizeX = sizeX
        boardSizeY = sizeY
        positions = tappedCells
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        boardSizeX = aDecoder.decodeInteger(forKey: boardSizeXKey)
        boardSizeY = aDecoder.decodeInteger(forKey: boardSizeYKey)
        positions = aDecoder.decodeObject(forKey: positionsKey) as! [String]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(boardSizeX, forKey: boardSizeXKey)
        aCoder.encode(boardSizeY, forKey: boardSizeYKey)
        aCoder.encode(positions, forKey: positionsKey)
    }
}
