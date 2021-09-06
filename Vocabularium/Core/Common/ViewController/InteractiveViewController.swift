//
//  InteractiveViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/12/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import Foundation

class InteractiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDraggableBehavior()
        setupTapRecognizers()
    }
    
    private func setupDraggableBehavior() {
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    private func setupTapRecognizers() {
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissAll))
        tapOnView.delegate = self
        tapOnView.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnView)
    }
    
    @objc private func dismissAll() {
        view.endEditing(true)
    }
}

extension InteractiveViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view is UIButton)) {
            return false
        }
        return true
    }
}
