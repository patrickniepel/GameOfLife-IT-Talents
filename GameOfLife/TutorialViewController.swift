//
//  TutorialViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 01.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    private var tutorialCtrl : TutorialController?
    private var dataSource : TutorialDataSource?
    private var delegate : TutorialDelegate?
    
    private var currentPage = 0
    private var totalPages = 0
    
    private var swipeLeft : UISwipeGestureRecognizer?
    private var swipeRight : UISwipeGestureRecognizer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialCtrl = TutorialController()

        dataSource = TutorialDataSource()
        delegate = TutorialDelegate()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        setupGesture()
        setupPageControl()
    }
    
    func setupGesture() {
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft?.direction = .left
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight?.direction = .right
        
        guard let swipeLeft = swipeLeft, let swipeRight = swipeRight else {
            return
        }
        
        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == .left {
            nextPage()
        }
        if gesture.direction == .right {
            prevPage()
        }
    }
    
    private func setupPageControl() {
        totalPages = tutorialCtrl?.getNumberOfPages() ?? TutorialController().getNumberOfPages()
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = totalPages
    }
    
    private func updatePageControl() {
        pageControl.currentPage = currentPage
    }
    
    func prevPage() {
        
        if currentPage - 1 < 0 {
            return
        }
        currentPage -= 1
        
        updatePageControl()
        
        let prevItem: IndexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: prevItem, at: .left, animated: true)
    }
    
    func nextPage() {
        
        if currentPage + 1 == totalPages {
            return
        }
        currentPage += 1
        
        updatePageControl()
        
        let nextItem: IndexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: nextItem, at: .right, animated: true)
    }
}
