//
//  FieldController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class FieldController: NSObject {
    
    var field : Field!
    var width : CGFloat  = 0
    var height : CGFloat = 0
    
    var tmpCells : [Cell] = []
    var allCells : [Cell] = []
    
    var cellCtrl : CellController!
    
    var cellBackGroundColor : UIColor!
    
    var stepCounter = 0
    
    init(fieldView: Field) {
        field = fieldView
        cellCtrl = CellController()
    }
    
    func setup(cellsPerRow: Int, cellsPerColumn: Int, color: UIColor) {
        
        field.cellsPerRow = cellsPerRow
        field.cellsPerColumn = cellsPerColumn
        cellBackGroundColor = color
    }
    
    /** Fills the game field with cells */
    func populateField() {
        
        let cellsPerRow = field.cellsPerRow
        width = field.frame.size.width / CGFloat(cellsPerRow)
        
        let cellsPerColumn = field.cellsPerColumn
        height = field.frame.size.height / CGFloat(cellsPerColumn)
        
        for j in 0..<cellsPerColumn {
            
            for i in 0..<cellsPerRow {
                
                let rect = CGRect(x: width * CGFloat(i), y: height * CGFloat(j), width: width, height: height)
                
                let cell = Cell(frame: rect)
                cell.color = cellBackGroundColor
                cell.setupForStart()
                
                field.addSubview(cell)
                
                let key = "\(i)|\(j)"
                field.cells[key] = cell
            }
        }
    }
    
    func colorCells(positions: [String]) {
        
        for pos in positions {
            field.cells[pos]?.backgroundColor = .black
        }
    }
    
    /** Sets the next generation of cells */
    func updateField() {
        
        for j in 0..<field.cellsPerColumn {
            
            for i in 0..<field.cellsPerRow {
                
                let key = "\(i)|\(j)"
                
                field.cells[key]?.setAppearance()
                
                let aliveCounter = cellCtrl.checkNeighbours(field: field, x: i, y: j)
                
                //Tot und genau 3 nachbarn
                if !field.cells[key]!.isAlive && aliveCounter == 3 {
                    field.cells[key]?.setAliveNextTurn(willBeAlive: true)
                }
                
                //Lebend mit  weniger als 2 nachbarn
                if field.cells[key]!.isAlive && aliveCounter < 2 {
                    field.cells[key]?.setAliveNextTurn(willBeAlive: false)
                }
                
                //Lebend mit 2 oder 3 lebenden nachbarn
                if field.cells[key]!.isAlive && (aliveCounter == 2 || aliveCounter == 3) {
                    field.cells[key]?.setAliveNextTurn(willBeAlive: true)
                }
                
                //Lebend mit mehr als 3 nachbarn
                if field.cells[key]!.isAlive && aliveCounter > 3 {
                    field.cells[key]?.setAliveNextTurn(willBeAlive: false)
                }
            }
        }
        
        for j in 0..<field.cellsPerColumn {
            
            for i in 0..<field.cellsPerRow {
                
                let key = "\(i)|\(j)"
                field.cells[key]?.setupForNextGeneration()
            }
        }
        
        stepCounter += 1
    }
    
    /** 0 = Ok, 1 = no cells alive, 2 = infinite, 3 = will stay the same */
    func checkForUpdates() -> Int {
        
        var stayedTheSame = true
        
        for cell in allCells {
            
            if cell.lifeWillChange {
                stayedTheSame = false
            }
        }
        
        if stayedTheSame && stepCounter != 0 {
            return 3
        }
    
        //If there is at least 1 cell that is alive return ok
        for cell in allCells {
            
            if cell.isAlive {
                return 0
            }
        }
        
        return 1
    }
    
    /** Sets the first generation after the field was created */
    func setInitialGeneration(initialGeneration: [String]) {
        
        for key in initialGeneration {
            
            field.cells[key]?.isAlive = true
            field.cells[key]?.setAppearance()
        }
        
        allCells = Array(field.cells.values)
    }
}
