//
//  LoadingDataSource.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class LoadingDataSource: NSObject, UITableViewDataSource {
    
    var loadingCtrl : LoadingController!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = loadingCtrl.getNumberOfGenerations()
        
        if count == 0 {
            return 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if loadingCtrl.getNumberOfGenerations() == 0 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Default text message will be shown
        if loadingCtrl.getNumberOfGenerations() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLoadingCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTableViewCell
        let generation = loadingCtrl.loadGeneration(row: indexPath.row)
        
        cell.name.text = generation.name
        cell.boardSizeX = generation.boardSizeX
        cell.boardSizeY = generation.boardSizeY
        cell.tappedCells = generation.positions
        
        //Setup Preview
        cell.setup()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            loadingCtrl.deleteGeneration(position: indexPath.row)
            
            if loadingCtrl.getNumberOfGenerations() == 0 {
                tableView.reloadRows(at: [indexPath], with: .top)
            }
            else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
