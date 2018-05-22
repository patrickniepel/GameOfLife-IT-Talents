//
//  CellController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class CellController: NSObject {
    
    func checkNeighbours(field: Field, x: Int, y: Int) -> Int {
        
        let cellsPerRow = field.cellsPerRow
        let cellsPerColumn = field.cellsPerColumn
        
        var counter = 0
        
        var minX = x - 1
        if minX < 0 {
            minX = cellsPerRow - 1
        }
        
        var minY = y - 1
        if minY < 0 {
            minY = cellsPerColumn - 1
        }
        
        let maxX = (x + 1) % cellsPerRow
        let maxY = (y + 1) % cellsPerColumn
        
        if field.cells["\(minX)|\(minY)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(minX)|\(y)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(minX)|\(maxY)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(x)|\(minY)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(x)|\(maxY)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(maxX)|\(minY)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(maxX)|\(y)"]!.isAlive {
            counter += 1
        }
        if field.cells["\(maxX)|\(maxY)"]!.isAlive {
            counter += 1
        }
        
        return counter
    }

}
