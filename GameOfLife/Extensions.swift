//
//  Extensions.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 26.10.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor:
                UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = .orange
    }
}
