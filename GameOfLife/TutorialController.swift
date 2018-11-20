//
//  TutorialController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 01.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

struct TutorialController {
    
    private let pages : [(UIImage, String)] = [
        (#imageLiteral(resourceName: "setup"), "\n\n\"Customize Your Board\""),
        (#imageLiteral(resourceName: "initial"), "\n\n\"Select The Initial Generation By Tapping On The Cells Or Dragging Your Finger\""),
        (#imageLiteral(resourceName: "zoom"), "\n\n\"Zoom In And Out\""),
        (#imageLiteral(resourceName: "loadSave"),"\n\n\"Load And Save Your Initial Generations\""),
        (#imageLiteral(resourceName: "forward"), "\n\n\"Speed Up Or Slow Down The Evolution By Activating The Buttons\""),
        (#imageLiteral(resourceName: "pause"), "\n\n\"Double Tap To Pause The Evolution\""),
        (#imageLiteral(resourceName: "shopTutorial"), "\n\n\"Check Out The Shop To Improve Your Game Experience\"")
    ]
    
    func getNumberOfPages() -> Int {
        return pages.count
    }
    
    func getPageData(for page: Int) -> (UIImage, String) {
        return pages[page]
    }
}
