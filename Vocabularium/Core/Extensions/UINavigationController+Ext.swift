//
//  UINavigationController+Ext.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

extension UINavigationController {
    func becomeTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }
    
    func becomeBlurred() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let bounds = navigationBar.bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
        // Create blur effect.
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualEffectView.frame = bounds
        // Set navigation bar up.
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .clear
        navigationBar.setBackgroundImage(nil, for: .default)
        self.view.backgroundColor = .clear
        visualEffectView.alpha = 0.2
        navigationBar.addSubview(visualEffectView)
    }
    
}
