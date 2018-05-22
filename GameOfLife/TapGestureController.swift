//
//  TapGestureController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 12.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class TapGestureController: NSObject {
    
    var field : Field!
    var width : CGFloat  = 0
    var height : CGFloat = 0
    var cellBackGroundColor : UIColor!
    
    var tappedCellKeys = [String]()
    
    init(fieldView: Field, color: UIColor) {
        field = fieldView
        cellBackGroundColor = color
    }
    
    func manageTargetGesture(location: CGPoint) {
        
        let cellsPerRow = field.cellsPerRow
        let cellsPerColumn = field.cellsPerColumn
        
        let width = field.frame.width / CGFloat(cellsPerRow)
        let height = field.frame.height / CGFloat(cellsPerColumn)
        
        let i = Int(location.x / width)
        let j = Int(location.y / height)
        
        let key = "\(i)|\(j)"
        let tappedCell = field.cells[key]!
        
        
        // Cell has already been selected and gets deselected now
        if tappedCellKeys.contains(key) {
            
            tappedCellKeys.remove(at: tappedCellKeys.index(of: key)!)
            tappedCell.backgroundColor = .white
        }
        // Cell hasn't been selected yet
        else {
            tappedCellKeys.append(key)
            field.bringSubview(toFront: tappedCell)
            tappedCell.backgroundColor = cellBackGroundColor
        }
    }
}
