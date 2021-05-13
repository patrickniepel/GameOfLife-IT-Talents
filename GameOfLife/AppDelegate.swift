//
//  AppDelegate.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//
//

import SwiftyStoreKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        // Deliver Content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
            }
        }

        // StoreManager.sharedInstance.countPurchasesToRestore()
        StoreManager.sharedInstance.getInfoForProducts()
        PersistencyController().loadUserData()
        return true
    }
}
