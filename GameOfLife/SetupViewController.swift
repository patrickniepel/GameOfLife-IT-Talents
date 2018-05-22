//
//  SetupViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet var colorButtons: [UIButton]!
    
    var delegate : Delegate!
    var dataSource : DataSource!
    
    var cellBackGroundColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = Delegate()
        pickerView.delegate = delegate
        
        dataSource = DataSource()
        pickerView.dataSource = dataSource
        
        for button in colorButtons {
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "setupVC2initialGenerationVC" {
            
            let destVC = segue.destination as! InitialGenerationViewController
            destVC.cellsPerRowSetup = delegate.cellsPerRow
            destVC.cellsPerColumnSetup = delegate.cellsPerColumn
            destVC.cellBackGroundColorSetup = cellBackGroundColor
        }
    }
    
    @IBAction func colorTapped(_ sender: UIButton) {
        
        for button in colorButtons {
            
            if button.layer.borderWidth == 2 {
                button.layer.borderWidth = 0
            }
        }

        sender.layer.borderWidth = 2
        cellBackGroundColor = sender.backgroundColor!
    }
}
