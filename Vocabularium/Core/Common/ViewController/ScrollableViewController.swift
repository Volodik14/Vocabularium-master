//
//  ScrollableViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/12/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import UIKit

class ScrollableViewController: InteractiveViewController {
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.backgroundColor = .none
        
        view.backgroundColor = .white
        
        // Add and setup scroll view
        self.view.addSubview(self.scrollView)
        self.view.bringSubviewToFront(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        // Constrain scroll view
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
    }
    
}
