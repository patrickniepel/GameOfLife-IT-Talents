//
//  PurchaseController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 01.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class PurchaseController: NSObject {
    
    private let adRemovalKey = "adRemoval"
    private let additionalCellsKey = "additionalCells"
    
    func userPurchasedAdRemoval() {
        UserDefaults.standard.set(true, forKey: adRemovalKey)
    }
    
    func didUserPurchaseAdRemoval() -> Bool {
        
        let didPurchase = UserDefaults.standard.bool(forKey: adRemovalKey)
        
        return didPurchase
    }
    
    func userPurchasedAdditionalCells() {
        UserDefaults.standard.set(true, forKey: additionalCellsKey)
    }
    
    func didUserPurchaseAdditionalCells() -> Bool {
        
        let didPurchase = UserDefaults.standard.bool(forKey: additionalCellsKey)
        
        return didPurchase
    }

}
