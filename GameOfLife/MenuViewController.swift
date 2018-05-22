//
//  MenuViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MenuViewController: UIViewController, GADBannerViewDelegate {


    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupButtons()
        animateButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeBanner()
    }

    private func removeBanner() {
        if !PurchaseController().didUserPurchaseAdRemoval() {
            loadBanner()
        }
        else {
            if bannerView != nil {
                bannerView.removeFromSuperview()
            }
        }
    }
    
    private func loadBanner() {
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = "ID"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        //Request
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "YourDeviceID"]
        bannerView.load(request)
    }
    
    private func setupButtons() {
        
        for btn in menuButtons {
            btn.layer.opacity = 0
            btn.layer.cornerRadius = 10
            
            btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn.layer.shadowOpacity = 1.0
            btn.layer.shadowRadius = 10.0
            btn.layer.masksToBounds = false
        }
    }
    
    private func animateButtons() {
        UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            for btn in self.menuButtons {
                btn.layer.opacity = 100
            }
        }, completion: nil)
    }
}
