//
//  FieldViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FieldViewController: UIViewController, UIScrollViewDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var fieldView: Field!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var pasteLabel: UILabel!
    @IBOutlet weak var runningStatusLabel: UILabel!
    
    var interstitial : GADInterstitial!
    
    var fieldCtrl : FieldController!
    
    var timer : Timer!
    
    var initialGeneration : Generation!
    
    var cellBackGroundColorSetup : UIColor!
    
    var tapGesture : UITapGestureRecognizer!
    var currentPace = 4
    var pastes : [Float] = [0.01, 0.1, 0.25, 0.5, 1, 2, 4]
    
    var didLayoutSubviews = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupBottomToolbar()
        
        if !PurchaseController().didUserPurchaseAdRemoval() {
            setupInterstitialAd()
        }
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didLayoutSubviews {
            
            fieldView.layoutIfNeeded()
            
            fieldCtrl = FieldController(fieldView: fieldView)
            fieldCtrl.setup(cellsPerRow: initialGeneration.boardSizeX, cellsPerColumn: initialGeneration.boardSizeY, color: cellBackGroundColorSetup)
            fieldCtrl.populateField()
            fieldCtrl.setInitialGeneration(initialGeneration: initialGeneration.positions)
            
            startTimer()
            
            didLayoutSubviews = true
        }
    }

    private func setupScrollView() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
    }
    
    private func setupBottomToolbar() {
        stepsLabel.text = "0 Step(s)"
        pasteLabel.text = "x1"
    }
    
    private func setupInterstitialAd() {
        interstitial = GADInterstitial(adUnitID: "ID")
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "YourDeviceID"]
        interstitial.load(request)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fieldView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       stopTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(pastes[currentPace]), target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        //Timer keeps firing even when zooming
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    private func checkIfNextGeneration() {
        
        //OK
        if fieldCtrl.checkForUpdates() == 0 {
            return
        }
        
        var alert : UIAlertController!
        stopTimer()
        
        //No cells alive
        if fieldCtrl.checkForUpdates() == 1 {
            alert = UIAlertController(title: "Game Over", message: "No More Cells Alive", preferredStyle: .alert)
        }
        
        //Infinite
        if fieldCtrl.checkForUpdates() == 2 {
            alert = UIAlertController(title: "Game Over", message: "Infinite Loop", preferredStyle: .alert)
        }
        
        //Stays the same
        if fieldCtrl.checkForUpdates() == 3 {
            alert = UIAlertController(title: "Game Over", message: "Evolution Will Not Continue", preferredStyle: .alert)
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { action -> Void in
            
            if !PurchaseController().didUserPurchaseAdRemoval() {
                self.showInterstitialAd()
            }
            else {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        
        alert.addAction(continueAction)
        
        self.present(alert, animated: true)
    }
    
    private func showInterstitialAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        else {
            print("Ad wasn't ready")
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    private func updatePasteLabel() {
        let paste = 1 / pastes[currentPace]
        print("Paste", paste)
        
        if paste >= 1 {
            let pasteInt = Int(paste * 1) / 1
            pasteLabel.text = "x\(pasteInt)"
        }
        else {
            pasteLabel.text = "x\(paste)"
        }
    }
    
    private func stopTimer() {
        
        if timer != nil {
            timer.invalidate()
        }
    }
    
    @objc func handleTimer() {
        checkIfNextGeneration()
        fieldCtrl.updateField()
        
        //The step after the last check does not count (this method will be completed -> update + 1 even when timer gets invalidated)
        stepsLabel.text = "\(fieldCtrl.stepCounter - 1) Step(s)"
    }
    
    /** User double tapped for pause or continue the game */
    @objc func handleTap() {
        
        if !timer.isValid {
            startTimer()
            runningStatusLabel.text = "Running"
        }
        else {
            timer.invalidate()
            runningStatusLabel.text = "Paused"
        }
    }
    
    @IBAction func fastForward(_ sender: UIBarButtonItem) {
        
        //Already at highest paste
        if currentPace - 1 < 0 {
            return
        }
        //Faster
        currentPace -= 1
        stopTimer()
        startTimer()
        updatePasteLabel()
    }
    
    @IBAction func rewind(_ sender: UIBarButtonItem) {
        
        if currentPace + 1 > pastes.count - 1 {
            return
        }
        //Slower
        currentPace += 1
        stopTimer()
        startTimer()
        updatePasteLabel()
    }
    
    deinit {
        self.view.removeGestureRecognizer(tapGesture)
    }
}
