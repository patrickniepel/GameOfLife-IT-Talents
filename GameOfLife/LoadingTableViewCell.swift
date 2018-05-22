//
//  LoadingTableViewCell.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var previewView: Field!
    
    var fieldCtrl : FieldController!
    var boardSizeX : Int!
    var boardSizeY : Int!
    var tappedCells : [String]!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /** Shows a little preview of the saved generation */
    func setup() {
        fieldCtrl = FieldController(fieldView: previewView)
        fieldCtrl.setup(cellsPerRow: boardSizeX, cellsPerColumn: boardSizeY, color: .black)
        fieldCtrl.populateField()
        fieldCtrl.colorCells(positions: tappedCells)
    }

}
