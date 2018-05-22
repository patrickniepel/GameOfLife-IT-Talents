//
//  PersistencyController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 17.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class PersistencyController: NSObject {
    
    func saveUserData(generation: Generation) {
        UserData.sharedInstance.generations.append(generation)
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
    }
    
    func loadUserData() {
        UserData.sharedInstance = DataObjectPersistency().loadDataObject()
    }
}
