//
//  ButtonAboveKeyboard.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 9/22/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonAboveKeyboard {
    var buttonAboveKeyboard: UIButton { get set }
    
//    func customizeAboveKeyboardButton(withColor: UIColor, title: String, action: Selector?)
    func showButtonAboveKeyboard(fromNotification notification: NSNotification?, ofView view: UIView, animated: Bool)
    func hideButtonAboveKeyboard(fromNotification notification: NSNotification?, ofView view: UIView, animated: Bool)
}

extension ButtonAboveKeyboard {
    var buttonAboveKeyboard: UIButton {
        get {
            let button = UIButton()
            button.backgroundColor = .systemBackground
            button.setTitle("Search definition", for: .normal)
            
            return button;
        } set {
            
        }
    }
    
    func showButtonAboveKeyboard(fromNotification notification: NSNotification?, ofView view: UIView, animated: Bool = true) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        if view.subviews.first(where: { $0.tag == 1000 }) != nil {
            
        } else {
            buttonAboveKeyboard.tag = 1000
            view.addSubview(buttonAboveKeyboard)
        }
        buttonAboveKeyboard.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(keyboardHeight)
            make.height.equalTo(50)
            make.width.equalTo(0.8 * view.frame.width)
        }
        
        setButtonVisibility(hidden: false, animated: animated)
    }
    
    func hideButtonAboveKeyboard(fromNotification notification: NSNotification?, ofView view: UIView, animated: Bool = true) {
        setButtonVisibility(hidden: true, animated: animated)
    }
    
    private func setButtonVisibility(hidden: Bool, animated: Bool) {
        guard animated else { buttonAboveKeyboard.alpha = hidden ? 0 : 1; return }
        UIView.animate(withDuration: 0.3) {
            self.buttonAboveKeyboard.alpha = hidden ? 0 : 1
        }
    }
}
