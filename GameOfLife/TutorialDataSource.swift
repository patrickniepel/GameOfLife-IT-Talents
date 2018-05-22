//
//  TutorialDataSource.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 01.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class TutorialDataSource: NSObject, UICollectionViewDataSource {
    
    var tutorialCtrl : TutorialController!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialCtrl.getNumberOfPages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as! TutorialCollectionViewCell
        
        let tutorialPage = tutorialCtrl.getPageData(for: indexPath.item)
        cell.tutorialImage.image = tutorialPage.0
        cell.tutorialText.text = tutorialPage.1
        cell.setup()
        
        return cell
    }
    
    
}
