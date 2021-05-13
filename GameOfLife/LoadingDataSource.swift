//
//  LoadingDataSource.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class LoadingDataSource: NSObject, UITableViewDataSource {
    
    var loadingCtrl : LoadingController?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = loadingCtrl?.getNumberOfGenerations() ?? 0
        
        if count == 0 { // swiftlint:disable:this empty_count
            return 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if loadingCtrl?.getNumberOfGenerations() == 0 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Default text message will be shown
        if loadingCtrl?.getNumberOfGenerations() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLoadingCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? LoadingTableViewCell
        let generation = loadingCtrl?.loadGeneration(row: indexPath.row)
        
        cell?.name.text = generation?.name
        cell?.boardSizeX = generation?.boardSizeX ?? 0
        cell?.boardSizeY = generation?.boardSizeY ?? 0
        cell?.tappedCells = generation?.positions ?? []
        
        //Setup Preview
        cell?.setup()
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            loadingCtrl?.deleteGeneration(position: indexPath.row)
            
            if loadingCtrl?.getNumberOfGenerations() == 0 {
                tableView.reloadRows(at: [indexPath], with: .top)
            }
            else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
