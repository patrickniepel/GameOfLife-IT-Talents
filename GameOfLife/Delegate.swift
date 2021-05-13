//
//  Delegate.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 12.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class Delegate: NSObject, UIPickerViewDelegate {
    var cellsPerRow = 3
    var cellsPerColumn = 3

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 3)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            cellsPerRow = row + 3
        } else {
            cellsPerColumn = row + 3
        }
    }

}
