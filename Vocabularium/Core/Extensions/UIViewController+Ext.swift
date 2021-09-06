//
//  UIViewController+Navigation.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Hero

extension UIViewController {
// MARK: - UIViewController + Navigation
    func setupRevealBehaviour(forButton button: UIBarButtonItem, usePanGesture: Bool = true) {
        button.target = self.revealViewController()
        button.action = #selector(SWRevealViewController.revealToggle(_:))
        guard let revealViewController = self.revealViewController() else { return }
        self.revealViewController()?.rearViewRevealWidth = 280
        
        if usePanGesture { self.view.addGestureRecognizer(revealViewController.panGestureRecognizer()) }
    }

    open func la() {
        
    }


// MARK: - UIViewController + SetupDelegates
    func tie(to collectionView: UICollectionView) {
        if let self = self as? UICollectionViewDelegate {
            collectionView.delegate = self
        }
        if let self = self as? UICollectionViewDataSource {
            collectionView.dataSource = self
        }
    }
    
    func tie(to tableView: UITableView) {
        if let self = self as? UITableViewDelegate {
            tableView.delegate = self
        }
        if let self = self as? UITableViewDataSource {
            tableView.dataSource = self
        }
    }
    
    func tie(to pickerView: UIPickerView) {
        if let self = self as? UIPickerViewDelegate {
            pickerView.delegate = self
        }
        if let self = self as? UIPickerViewDataSource {
            pickerView.dataSource = self
        }
    }
    

// MARK: - Add Overlay Buttons
    
    func addCreateButton() {
        let createButton = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        createButton.hero.id = "AddTermMain"
        createButton.hero.isEnabled = true
        
        createButton.hero.modifiers = [.duration(0.5)]
        createButton.backgroundColor = .white
        createButton.tag = 1001
        createButton.tintColor = .black
        createButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        createButton.layer.cornerRadius = 15
        createButton.setSlightShadow(length: 4)
        
        view.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).inset(50)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(Constants.UIConfiguration.StaticSizes.basicAddTermButtonWidth)
            make.width.equalTo(createButton.snp.height)
        }
        view.layoutIfNeeded()
    }
    
    func addSearchButton() {
        let createButton = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        createButton.hero.id = "SearchMain"
        createButton.hero.isEnabled = true
        
        createButton.hero.modifiers = [.duration(0.5)]
        createButton.backgroundColor = .white
        createButton.tag = 2002
        createButton.tintColor = .black
        createButton.setImage(UIImage(named: "Search"), for: .normal)
        createButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        createButton.layer.cornerRadius = 15
        createButton.setSlightShadow(length: 4)
        
        view.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(50)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(Constants.UIConfiguration.StaticSizes.basicAddTermButtonWidth)
            make.width.equalTo(createButton.snp.height)
        }
        view.layoutIfNeeded()
    }
    
    func addFilterButton() {
        let createButton = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        createButton.hero.id = "AddTermMain"
        createButton.hero.isEnabled = true
        
        createButton.hero.modifiers = [.duration(0.5)]
        createButton.backgroundColor = .white
        createButton.tag = 1001
        createButton.tintColor = .black
        createButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        createButton.layer.cornerRadius = 15
        createButton.setSlightShadow(length: 4)
        
        view.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).inset(50)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(Constants.UIConfiguration.StaticSizes.basicAddTermButtonWidth)
            make.width.equalTo(createButton.snp.height)
        }
        view.layoutIfNeeded()
    }
    

// MARK: - Button Accessors
        var createButton: UIButton? {
            var createButton: UIButton? = nil
            for subview in view.subviews {
                if subview.tag == 1001 {
                    createButton = subview as? UIButton
                    break
                }
            }
            return createButton
        }

    
    
}
