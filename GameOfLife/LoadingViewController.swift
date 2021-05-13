//
//  LoadingViewController.swift
//  GameOfLife
//
//  Created by Patrick Niepel on 18.11.17.
//  Copyright © 2017 Patrick Niepel. All rights reserved.
//

import UIKit

protocol LoadingSegueDelegate: AnyObject {
    func closeFromLoadingScreen(ctrl: LoadingViewController)
    func loadFromLoadingScreen(ctrl: LoadingViewController, generation: Generation)
}

class LoadingViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!

    weak var segueDelegate: LoadingSegueDelegate?
    private var dataSource: LoadingDataSource?
    private var delegate: LoadingDelegate? // swiftlint:disable:this weak_delegate
    private var loadingCtrl: LoadingController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        loadingCtrl = LoadingController()

        dataSource = LoadingDataSource()
        delegate = LoadingDelegate()

        dataSource?.loadingCtrl = loadingCtrl
        delegate?.loadingCtrl = loadingCtrl

        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    private func setupUI() {
        topView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        closeButton.layer.cornerRadius = 10
    }

    /** Loads chosen generation into the Initial Generation screen */
    func loadFromLoadingScreen(generation: Generation) {
        segueDelegate?.loadFromLoadingScreen(ctrl: self, generation: generation)
    }

    private func closeLoadingScreen() {
        segueDelegate?.closeFromLoadingScreen(ctrl: self)
    }

    @IBAction func close(_ sender: UIButton) {
        closeLoadingScreen()
    }
}
