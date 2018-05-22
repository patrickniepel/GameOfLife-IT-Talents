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
        
        // neighbours of cell at x|y getting checked
        
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
        
        // top left
        if field.cells["\(minX)|\(minY)"]!.isAlive {
            counter += 1
        }
        
        // left mid
        if field.cells["\(minX)|\(y)"]!.isAlive {
            counter += 1
        }
        
        // bottom left
        if field.cells["\(minX)|\(maxY)"]!.isAlive {
            counter += 1
        }
        
        // top mid
        if field.cells["\(x)|\(minY)"]!.isAlive {
            counter += 1
        }
        
        // bottom mid
        if field.cells["\(x)|\(maxY)"]!.isAlive {
            counter += 1
        }
        
        // top right
        if field.cells["\(maxX)|\(minY)"]!.isAlive {
            counter += 1
        }
        
        // right mid
        if field.cells["\(maxX)|\(y)"]!.isAlive {
            counter += 1
        }
        
        // bottom right
        if field.cells["\(maxX)|\(maxY)"]!.isAlive {
            counter += 1
        }
        
        return counter
    }

}
