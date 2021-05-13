//
//  TapGestureController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 12.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class TapGestureController: NSObject {
    private var field: Field?
    private var width: CGFloat  = 0
    private var height: CGFloat = 0
    private var cellBackGroundColor: UIColor = .white
    private var lastTappedCellKey = ""

    var tappedCellKeys = [String]()

    init(fieldView: Field, color: UIColor) {
        field = fieldView
        cellBackGroundColor = color
    }

    func manageTargetGesture(location: CGPoint) {
        guard let field = field else {
            return
        }

        let cellsPerRow = field.cellsPerRow
        let cellsPerColumn = field.cellsPerColumn

        let width = field.frame.width / CGFloat(cellsPerRow)
        let height = field.frame.height / CGFloat(cellsPerColumn)

        let i = Int(location.x / width)
        let j = Int(location.y / height)

        let key = "\(i)|\(j)"

        guard let tappedCell = field.cells[key] else {
            return
        }

        // User is still on the same cell
        if key == lastTappedCellKey {
            return
        }

        // Cell has already been selected and gets deselected now
        if tappedCellKeys.contains(key) {
            if let index = tappedCellKeys.firstIndex(of: key) {
                tappedCellKeys.remove(at: index)
                tappedCell.backgroundColor = .white
            }
        } else { // Cell hasn't been selected yet
            tappedCellKeys.append(key)
            field.bringSubviewToFront(tappedCell)
            tappedCell.backgroundColor = cellBackGroundColor
        }

        lastTappedCellKey = key
    }
}
