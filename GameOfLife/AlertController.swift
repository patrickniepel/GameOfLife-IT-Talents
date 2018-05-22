//
//  AlertController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 17.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class AlertController: NSObject {
    
    func createSaveAlert(generation: Generation) -> UIAlertController {
        
        let alert = UIAlertController(title: "Save Generation", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
            
            guard let textField = alert.textFields?.first else { return }
            
            if self.checkTextFieldInput(tf: textField) {
                generation.name = textField.text!
            }
            else {
                let name = "Custom Generation"
                generation.name = name
            }
            PersistencyController().saveUserData(generation: generation)
            print("saved")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        
        alert.addTextField { action -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        return alert
    }
    
    func checkTextFieldInput(tf: UITextField) -> Bool {
        guard let text = tf.text else { return false }
        
        if text.trimmingCharacters(in: .whitespaces).count == 0 {
            return false
        }
        return true
    }

}
