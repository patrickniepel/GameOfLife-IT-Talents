//
//  DataSource.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 12.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class DataSource: NSObject, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if PurchaseController().didUserPurchaseAdditionalCells() {
            return 48
        }
        return 28
    }
}
