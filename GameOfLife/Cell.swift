//
//  Cell.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class Cell: UIView {
    
    //var fieldPosition = [String : Int]()
    
    var isAlive = false
    
    //Background color if alive
    var color = UIColor.black
    
    var stateWillChange = false
    
    private var nextGenerationAlive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupForStart() {
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = color.cgColor
    }
    
    func setupForNextGeneration() {
        stateWillChange = isAlive == nextGenerationAlive ? false : true
        isAlive = nextGenerationAlive
    }
    
    func setStateNextTurn(willBeAlive : Bool) {
        nextGenerationAlive = willBeAlive
    }
    
    func setAppearance() {
        
        if isAlive {
            self.backgroundColor = color
        }
        else {
            self.backgroundColor = .white
        }
    }
}
