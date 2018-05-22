//
//  NetworkActivityIndicatorManager.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 02.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func networkOperationStarted() {
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished() {
        
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
