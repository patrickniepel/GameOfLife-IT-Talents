//
//  ShopTableViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 07.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class ShopTableViewController: UITableViewController {
    let storeManager = StoreManager.sharedInstance

    private var removeAd = RegisteredPurchase.removeAd
    private var expandBoard = RegisteredPurchase.expandBoard

    @IBOutlet weak var removeAdButton: UIButton!
    @IBOutlet weak var expandBoardButton: UIButton!
    @IBOutlet weak var restoreButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove separator
        tableView.tableFooterView = UIView()

        setupLayout()
        handleButtonEnabling()
        // checkRestoreButtonEnabled()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleButtonEnabling), name: NSNotification.Name("handleButtonEnabling"), object: nil)
        nc.addObserver(self, selector: #selector(showAlert), name: NSNotification.Name("showAlert"), object: nil)
        nc.addObserver(self, selector: #selector(purchasesRestored), name: NSNotification.Name("purchasesRestored"), object: nil)
    }

    private func setupLayout() {
        removeAdButton.layer.cornerRadius = 10
        expandBoardButton.layer.cornerRadius = 10
        if let removeAdPrice = storeManager.myProductsPrices["removeAdPrice"] {
            removeAdButton.setTitle(removeAdPrice, for: .normal)
        }

        if let expandBoardPrice = storeManager.myProductsPrices["expandBoardPrice"] {
            expandBoardButton.setTitle(expandBoardPrice, for: .normal)
        }
    }

    /** Changes button appearance when user purchased a product */
    @objc
    func handleButtonEnabling() {
        if PurchaseController().didUserPurchaseAdRemoval() {
            removeAdButton.isEnabled = false
            removeAdButton.backgroundColor = .gray
            removeAdButton.setTitleColor(.white, for: .normal)
        }

        if PurchaseController().didUserPurchaseAdditionalCells() {
            expandBoardButton.isEnabled = false
            expandBoardButton.backgroundColor = .gray
            expandBoardButton.setTitleColor(.white, for: .normal)
        }
        // checkRestoreButtonEnabled()
    }

    @objc
    func showAlert(notification: NSNotification) {
        guard let alert = notification.object as? UIAlertController else { return }
        if self.presentedViewController == nil {
            self.present(alert, animated: true)
        }
    }

    @objc
    func purchasesRestored() {
        handleButtonEnabling()
        // checkRestoreButtonEnabled()
    }

    //    private func checkRestoreButtonEnabled() {
//
//        let didBuyRemoveAd = PurchaseController().didUserPurchaseAdRemoval()
//        let didBuyExpandBoard = PurchaseController().didUserPurchaseAdditionalCells()
//
//        if !didBuyRemoveAd && !didBuyExpandBoard && storeManager.productsToRestore.count > 0 {
//            restoreButton.isEnabled = true
//        }
//        else {
//            restoreButton.isEnabled = false
//        }
//    }

    /** User wants to remove the ad */
    @IBAction func removeAd(_ sender: UIButton) {
        storeManager.purchase(purchase: removeAd)
    }

    /** User wants to purchase the board expansion */
    @IBAction func expandBoard(_ sender: UIButton) {
        storeManager.purchase(purchase: expandBoard)
    }

    @IBAction func restorePurchases(_ sender: UIBarButtonItem) {
        storeManager.restorePurchases()
    }

    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name("handleButtonEnabling"), object: nil)
        nc.removeObserver(self, name: NSNotification.Name("showAlert"), object: nil)
        nc.removeObserver(self, name: NSNotification.Name("purchasesRestored"), object: nil)
    }
}
