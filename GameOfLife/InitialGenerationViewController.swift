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
    
    private var tapGestureCtrl : TapGestureController?
    private var fieldCtrl : FieldController?
    
    private var panRecognizer : UIPanGestureRecognizer?
    private var tapRecognizer : UITapGestureRecognizer?
    
    var cellsPerRowSetup : Int?
    var cellsPerColumnSetup : Int?
    var cellBackGroundColorSetup : UIColor?
    
    private var didLayoutSubviews = false
    
    private var initialGeneration = Generation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()

        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        guard let panRecognizer = panRecognizer, let tapRecognizer = tapRecognizer else {
            return
        }
        
        scrollView.addGestureRecognizer(panRecognizer)
        scrollView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didLayoutSubviews {
            fieldView.layoutIfNeeded()
            
            fieldCtrl = FieldController(fieldView: fieldView)
            setupField()
            
            tapGestureCtrl = TapGestureController(fieldView: fieldView, color: cellBackGroundColorSetup ?? .white)
            
            didLayoutSubviews = true
        }
    }
    
    private func setupField() {
        fieldCtrl?.setup(cellsPerRow: cellsPerRowSetup ?? 0, cellsPerColumn: cellsPerColumnSetup ?? 0, color: cellBackGroundColorSetup ?? .white)
        fieldCtrl?.populateField()
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
    
    // MARK: - SegueDelegates
    
    func closeFromLoadingScreen(ctrl: LoadingViewController) {
        ctrl.dismiss(animated: true, completion: nil)
    }
    
    func loadFromLoadingScreen(ctrl: LoadingViewController, generation: Generation) {
        initialGeneration = generation
        reloadViewWithNewGeneration()
        
        ctrl.dismiss(animated: true, completion: nil)
    }
    
    // --
    
    private func reloadViewWithNewGeneration() {
        
        // Remove already added CGRects as Cells
        removeSubviews()
        
        cellsPerRowSetup = initialGeneration.boardSizeX
        cellsPerColumnSetup = initialGeneration.boardSizeY
        setupField()
        
        //Load positions of the loaded generation into the tappedCellKeys for correct further editing
        tapGestureCtrl?.tappedCellKeys = initialGeneration.positions
        fieldCtrl?.colorCells(positions: initialGeneration.positions)
    }
    
    private func removeSubviews() {
        for subview in fieldView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @objc func handleTap(gesture: UIPanGestureRecognizer) {

        let location = gesture.location(in: gesture.view)
        
        //Sometimes there will be a negative value for the location (Bug?)
        if location.x < 0 || location.y < 0 {
            return
        }
        
        tapGestureCtrl?.manageTargetGesture(location: location)
    }
    
    @IBAction func startGame(_ sender: UIBarButtonItem) {
        
        //Cannot start the game if there are no cells selected
        if tapGestureCtrl?.tappedCellKeys.count == 0 {
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
        
        if tapGestureCtrl?.tappedCellKeys.count == 0 {
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
        let tappedCells = tapGestureCtrl?.tappedCellKeys
        
        let generationToSave = Generation()
        generationToSave.boardSizeX = cellsPerRowSetup ?? 0
        generationToSave.boardSizeY = cellsPerColumnSetup ?? 0
        generationToSave.positions = tappedCells ?? []
        
        return generationToSave
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "initialGenerationVC2fieldVC" {
            
            let destVC = segue.destination as? FieldViewController
            
            initialGeneration = setupInitialGeneration()
            destVC?.initialGeneration = initialGeneration
            destVC?.cellBackGroundColorSetup = cellBackGroundColorSetup
        }
        
        if segue.identifier == "initialGenerationVC2loadingVC" {
            
            let destVC = segue.destination as? LoadingViewController
            destVC?.segueDelegate = self
        }
    }
    
    deinit {
        guard let panRecognizer = panRecognizer, let tapRecognizer = tapRecognizer else {
            return
        }
        scrollView.removeGestureRecognizer(panRecognizer)
        scrollView.removeGestureRecognizer(tapRecognizer)
    }
}
