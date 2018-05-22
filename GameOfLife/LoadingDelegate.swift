//
//  LoadingDelegate.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class LoadingDelegate: NSObject, UITableViewDelegate {
    
    var loadingCtrl : LoadingController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generation = loadingCtrl.loadGeneration(row: indexPath.row)
        
        let nav = tableView.window?.rootViewController as! UINavigationController
        let topVC = nav.presentedViewController as! LoadingViewController
        
        //Start loading the selected generation
        topVC.loadFromLoadingScreen(generation: generation)
    }

}
