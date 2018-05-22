//
//  LoadingController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class LoadingController: NSObject {
    
    func getNumberOfGenerations() -> Int {
        return UserData.sharedInstance.generations.count
    }
    
    func loadGeneration(row: Int) -> Generation {
        return UserData.sharedInstance.generations[row]
    }
    
    func deleteRow(row: Int) {
        UserData.sharedInstance.generations.remove(at: row)
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
    }

}
