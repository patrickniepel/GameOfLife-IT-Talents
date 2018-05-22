//
//  InitialGenerationViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 12.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class InitialGenerationViewController: UIViewController, UIScrollViewDelegate, LoadingSegueDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldView: Field!
    
    var tapGestureCtrl : TapGestureController!
    var fieldCtrl : FieldController!
    
    var gestureRecognizer : UITapGestureRecognizer!
    
    var cellsPerRowSetup : Int!
    var cellsPerColumnSetup : Int!
    var cellBackGroundColorSetup : UIColor!
    
    var didLayoutSubviews = false
    
    var initialGeneration = Generation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()

        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didLayoutSubviews {
            fieldView.layoutIfNeeded()
            
            fieldCtrl = FieldController(fieldView: fieldView)
            setupField()
            
            tapGestureCtrl = TapGestureController(fieldView: fieldView, color: cellBackGroundColorSetup)
            
            didLayoutSubviews = true
            
            print(scrollView.frame.height)
            print(fieldView.frame.height)
        }
    }
    
    private func setupField() {
        fieldCtrl.setup(cellsPerRow: cellsPerRowSetup, cellsPerColumn: cellsPerColumnSetup, color: cellBackGroundColorSetup)
        fieldCtrl.populateField()
    }
    
    /** View that will be zoomed when pinching */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fieldView
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
    }
    
    func closeFromLoadingScreen(ctrl: LoadingViewController) {
        ctrl.dismiss(animated: true, completion: nil)
    }
    
    func loadFromLoadingScreen(ctrl: LoadingViewController, generation: Generation) {
        initialGeneration = generation
        reloadViewWithGeneration()
        
        ctrl.dismiss(animated: true, completion: nil)
    }
    
    private func reloadViewWithGeneration() {
        removeSubviews()
        cellsPerRowSetup = initialGeneration.boardSizeX
        cellsPerColumnSetup = initialGeneration.boardSizeY
        setupField()
        tapGestureCtrl.tappedCellKeys = initialGeneration.positions
        fieldCtrl.colorCells(positions: initialGeneration.positions)
    }
    
    private func removeSubviews() {
        for subview in fieldView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {

        let location = gesture.location(in: gesture.view)
        
        //Sometimes there will be a negative value for the location (Bug?)
        if location.x < 0 || location.y < 0 {
            return
        }
        
        tapGestureCtrl.manageTargetGesture(location: location)
    }
    
    @IBAction func startGame(_ sender: UIBarButtonItem) {
        
        if tapGestureCtrl.tappedCellKeys.count == 0 {
            showAlert()
        }
        else {
            performSegue(withIdentifier: "initialGenerationVC2fieldVC", sender: nil)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "No Cells Selected", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func saveGeneration(_ sender: UIBarButtonItem) {
        
        if tapGestureCtrl.tappedCellKeys.count == 0 {
            showAlert()
        }
        else {
            createSaveAlert()
        }
    }
    
    private func createSaveAlert() {
        let generationToSave = setupInitialGeneration()
        let alert = AlertController().createSaveAlert(generation: generationToSave)
        present(alert, animated: true)
    }
    
    private func setupInitialGeneration() -> Generation {
        let tappedCells = tapGestureCtrl.tappedCellKeys
        
        let generationToSave = Generation()
        generationToSave.boardSizeX = cellsPerRowSetup
        generationToSave.boardSizeY = cellsPerColumnSetup
        generationToSave.positions = tappedCells
        
        return generationToSave
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "initialGenerationVC2fieldVC" {
            
            let destVC = segue.destination as! FieldViewController
            
            initialGeneration = setupInitialGeneration()
            destVC.initialGeneration = initialGeneration
            destVC.cellBackGroundColorSetup = cellBackGroundColorSetup
        }
        
        if segue.identifier == "initialGenerationVC2loadingVC" {
            
            let destVC = segue.destination as! LoadingViewController
            destVC.segueDelegate = self
        }
    }
    
    deinit {
        scrollView.removeGestureRecognizer(gestureRecognizer)
    }
}