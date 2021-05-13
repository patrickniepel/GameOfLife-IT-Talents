//
//  MenuViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 10.09.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var menuButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupButtons()
        animateButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func setupButtons() {
        
        for btn in menuButtons {
            btn.layer.opacity = 0
            btn.layer.cornerRadius = 15
            
            btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            btn.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn.layer.shadowOpacity = 1.0
            btn.layer.shadowRadius = 15.0
            btn.layer.masksToBounds = false
        }
    }
    
    private func animateButtons() {
        UIView.animate(withDuration: 2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            for btn in self.menuButtons {
                btn.layer.opacity = 100
            }
        }, completion: nil)
    }
}
