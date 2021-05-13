//
//  StoreManager.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 03.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

let sharedSecret = "SHARED_SECRET"

enum RegisteredPurchase : String {
    
    case removeAd = "RemoveAd"
    case expandBoard = "ExpandBoard"
}

class StoreManager: NSObject {
    
    private override init() {}
    static let sharedInstance = StoreManager()
    
    private let bundleID = "de.patrickniepel.GameOfLife"
    private var removeAd = RegisteredPurchase.removeAd
    private var expandBoard = RegisteredPurchase.expandBoard
    private var productsToRestore : [Purchase] = []
    var myProductsPrices : [String : String] = [:]
    

    // SwiftyStoreKit
    
    func getInfoForProducts() {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + removeAd.rawValue, bundleID + "." + expandBoard.rawValue], completion: { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in  result.retrievedProducts {
                
                if product.productIdentifier == self.bundleID + "." + RegisteredPurchase.removeAd.rawValue {
                    
                    if let price = product.localizedPrice {
                        self.myProductsPrices["removeAdPrice"] = price
                    }
                }
                
                if product.productIdentifier == self.bundleID + "." + RegisteredPurchase.expandBoard.rawValue {
                    
                    if let price = product.localizedPrice {
                        self.myProductsPrices["expandBoardPrice"] = price
                    }
                }
            }
           
            
            //self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
        })
    }
    
    func purchase(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let product) = result {
                
                if product.productId == self.bundleID + "." + RegisteredPurchase.removeAd.rawValue {
                    PurchaseController().userPurchasedAdRemoval()
                }
                
                if product.productId == self.bundleID + "." + RegisteredPurchase.expandBoard.rawValue {
                    PurchaseController().userPurchasedAdditionalCells()
                }
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                //Disable Buttons
                NotificationCenter.default.post(name: NSNotification.Name("handleButtonEnabling"), object: nil)
            }
            
            if let alert = self.alertForPurchaseResult(result: result) {
                self.showAlert(alert: alert)
            }
        })
    }
    
    func countPurchasesToRestore() {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, applicationUsername: UIDevice.current.name, completion: { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in result.restoredPurchases where product.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(product.transaction)
            }
            
            for pro in result.restoredPurchases {

                if pro.productId == self.bundleID + "." + RegisteredPurchase.removeAd.rawValue {
                    self.productsToRestore.append(pro)
                }
                
                if pro.productId == self.bundleID + "." + RegisteredPurchase.expandBoard.rawValue {
                    self.productsToRestore.append(pro)
                }
            }
            
        })
    }
    
    func restorePurchases() {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, applicationUsername: UIDevice.current.name, completion: { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in result.restoredPurchases where product.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(product.transaction)
            }
        
            for pro in result.restoredPurchases {
                
                if pro.productId == self.bundleID + "." + RegisteredPurchase.removeAd.rawValue {
                    PurchaseController().userPurchasedAdRemoval()
                }
                
                if pro.productId == self.bundleID + "." + RegisteredPurchase.expandBoard.rawValue {
                    PurchaseController().userPurchasedAdditionalCells()
                }
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
        })
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.networkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
        }
    }
    
    func verifyPurchase(product: RegisteredPurchase) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
                
            case .success(let receipt):
                let productID = self.bundleID + "." + product.rawValue
                
                switch product {
                    
                    //case == .autoRenewable
                    //let purchaseResult = SwiftyStoreKit.verifySubscription(type: .autoRenewable, productId: productID, inReceipt: receipt, validUntil: Date())
                    //self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                    
                    //case == .nonRenewing
                    //let purchaseResult = SwiftyStoreKit.verifySubscription(type: .nonRenewing(validDuration: 60), productId: productID, inReceipt: receipt, validUntil: Date())
                    //self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                    
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                    self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                }
                
            case .error:
                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            }
        }
    }
}

extension StoreManager {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        NotificationCenter.default.post(name: NSNotification.Name("showAlert"), object: alert)
    }
    
    func alertForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice ?? "Error"
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could Not Retrieve Product Info", message: "Invalid Product Identifier: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unkown Error. Please Contact Support!"
            return alertWithTitle(title: "Could Not Retrieve Product Info", message: errorString)
        }
    }

    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(result: PurchaseResult) -> UIAlertController? {
        switch result {
            
        case .success:
            return alertWithTitle(title: "Thank You", message: "Purchase Completed")
            
        case .error(let error):
            
            switch error.code { 
            case .unknown:
                return alertWithTitle(title: "Purchase Failed", message: "\(error.localizedDescription). Check Your Internet Connection Or Contact Support!")
            case .clientInvalid:
                return alertWithTitle(title: "Purchase Failed", message: "You Are Not Allowed To Make The Payment!")
            case .paymentCancelled:
                return nil
            case .paymentInvalid:
                return alertWithTitle(title: "Purchase Failed", message: "Try Again Later Or Contact Support!")
            case .paymentNotAllowed:
                return alertWithTitle(title: "Purchase Failed", message: "The Device Is Not Allowed To Make The Payment!")
            case .storeProductNotAvailable:
                return alertWithTitle(title: "Purchase Failed", message: "The Product Is Not Available In The Current Storefront!")
            case .cloudServicePermissionDenied:
                return alertWithTitle(title: "Purchase Failed", message: "Access To Cloud Service Information Is Not Allowed!")
            case .cloudServiceNetworkConnectionFailed:
                return alertWithTitle(title: "Purchase Failed", message: "Could Not Connect To The Network!")
            case .cloudServiceRevoked:
                return alertWithTitle(title: "Purchase Failed", message: "Cloud Service Was Revoked!")
            case .privacyAcknowledgementRequired:
                return nil
            case .unauthorizedRequestData:
                return nil
            case .invalidOfferIdentifier:
                return nil
            case .invalidSignature:
                return nil
            case .missingOfferParams:
                return nil
            case .invalidOfferPrice:
                return nil
            case .overlayCancelled:
                return nil
            case .overlayInvalidConfiguration:
                return nil
            case .overlayTimeout:
                return nil
            case .ineligibleForOffer:
                return nil
            case .unsupportedPlatform:
                return nil
            case .overlayPresentedInBackgroundScene:
                return nil
            }
        }
    }
    
    func alertForRestorePurchases(result: RestoreResults) -> UIAlertController {
        if !result.restoreFailedPurchases.isEmpty {
            return alertWithTitle(title: "Restore Failed", message: "Check Your Internet Connection Or Contact Support!")
        }
        else if !result.restoredPurchases.isEmpty {
            
            NotificationCenter.default.post(name: NSNotification.Name("purchasesRestored"), object: nil)
            return alertWithTitle(title: "Purchases Restored", message: "All Purchases Have Been Restored")
        }
        else {
            return alertWithTitle(title: "Nothing To Restore", message: "No Previous Purchases Were Made")
        }
    }
    
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        switch result {
            
        case .success:
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
            
        case .error(let error):
            
            
            switch error {
                
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No Receipt Data Found, Application Will Try To Get A New One. Try Again!")
            case .networkError:
                return alertWithTitle(title: "Receipt Verification", message: "Network Error While Verifying Receipt!")
            default:
                return alertWithTitle(title: "Receipt Verification", message: "Receipt Verification Failed!")
            }
        }
    }
    
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
            
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product Is Purchased", message: "Product Is Valid unitl \(expiryDate)")
        case .notPurchased:
            return alertWithTitle(title: "Not Purchased", message: "This Product Has Never Been Purchased")
        case .expired(let expiryDate):
            return alertWithTitle(title: "Product Expired", message: "Product Is Expired Sinces \(expiryDate)")
        }
    }
    
    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController {
        switch result {
            
        case .purchased:
            return alertWithTitle(title: "Product Is Purchased", message: "Product Will Not Expire")
        case .notPurchased:
            return alertWithTitle(title: "Product Not Purchased", message: "Product Has Never Been Purchased")
        }
    }
}
