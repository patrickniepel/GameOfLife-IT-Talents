//
//  UserData.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 17.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

/** Represents for the saved generations the user created  */
class UserData: NSObject, NSCoding {
    
    static var sharedInstance = UserData()
    
    var generations : [Generation] = []

    private let generationsKey = "generation"

    
    private override init(){}
    
    required init?(coder aDecoder: NSCoder) {
        generations = aDecoder.decodeObject(forKey: generationsKey) as? [Generation] ?? []
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(generations, forKey: generationsKey)
    }
}
