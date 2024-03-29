//
//  FieldController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class FieldController: NSObject {
    private var field: Field?
    private var width: CGFloat  = 0
    private var height: CGFloat = 0

    // var tmpCells : [Cell] = []
    private var allCells: [Cell] = []
    private var cellCtrl: CellController?
    private var cellBackGroundColor: UIColor = .white

    var stepCounter = 0

    init(fieldView: Field) {
        field = fieldView
        cellCtrl = CellController()
    }

    func setup(cellsPerRow: Int, cellsPerColumn: Int, color: UIColor) {
        field?.cellsPerRow = cellsPerRow
        field?.cellsPerColumn = cellsPerColumn
        cellBackGroundColor = color
    }

    /** Fills the board with cells */
    func populateField() {
        guard let field = field else {
            return
        }

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
            field?.cells[pos]?.backgroundColor = cellBackGroundColor
        }
    }

    /** Sets the next generation of cells */
    func updateField() {
        guard let field = field else {
            return
        }

        // check cell states for next generation
        for column in 0..<field.cellsPerColumn {
            for row in 0..<field.cellsPerRow {
                let key = "\(row)|\(column)"
                field.cells[key]?.setAppearance()
                let aliveCounter = cellCtrl?.checkNeighbours(field: field, x: row, y: column) ?? 0

                // Dead and exactly three living neighbours
                if let cell = field.cells[key], aliveCounter == 3, !cell.isAlive {
                    field.cells[key]?.setStateNextTurn(willBeAlive: true)
                }

                // Alive and less than two living neighbours
                if let cell = field.cells[key], aliveCounter < 2, cell.isAlive {
                    field.cells[key]?.setStateNextTurn(willBeAlive: false)
                }

                // Alive and two or three living neighbours
                if let cell = field.cells[key], (aliveCounter == 2 || aliveCounter == 3), cell.isAlive {
                    field.cells[key]?.setStateNextTurn(willBeAlive: true)
                }

                // Alive and more than three living neighbours
                if let cell = field.cells[key], aliveCounter > 3, cell.isAlive {
                    field.cells[key]?.setStateNextTurn(willBeAlive: false)
                }
            }
        }

        // Commit changes for next generation
        let allKeys = field.cells.keys
        allKeys.forEach { key in
            field.cells[key]?.setupForNextGeneration()
        }

        stepCounter += 1
    }

    /** 0 = Ok, 1 = no cells alive, 2 = infinite, 3 = will stay the same */
    func checkForUpdates() -> Int {
        var stayedTheSame = true

        for cell in allCells where cell.stateWillChange {
            stayedTheSame = false
        }

        if stayedTheSame && stepCounter != 0 {
            return 3
        }

        // If there is at least 1 cell that is alive return ok
        for cell in allCells where cell.isAlive {
            return 0
        }

        return 1
    }

    /** Sets the first generation after the field was created */
    func setInitialGeneration(initialGenerationPositions: [String]) {
        guard let field = field else { return }

        for pos in initialGenerationPositions {
            field.cells[pos]?.isAlive = true
            field.cells[pos]?.setAppearance()
        }

        allCells = Array(field.cells.values)
    }
}
