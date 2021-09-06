//
//  InputField.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 7/1/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
class InputField: UITextView {
    
    @IBInspectable var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        placeholderLabel.font = UIFont.systemFont(ofSize: ((self.font as AnyObject).pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 15, y: ((self.font as AnyObject).pointSize)! / 2 + 3)
        placeholderLabel.isHidden = !self.text.isEmpty
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.textAlignment = .center
        
        self.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        self.isScrollEnabled = false
        self.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        self.layer.cornerRadius = 10
    }
    
    @IBInspectable var underlineHeight: CGFloat = 2 {
        didSet {
            updateUnderline()
        }
    }
    @IBInspectable var underlineColor: UIColor = .systemRed {
        didSet {
            updateUnderline()
        }
    }
    @IBInspectable var shouldShowUnderline: Bool = true {
        didSet {
            if shouldShowUnderline == true {
                underlineColor = .systemGray
            } else {
                underlineColor = .systemBackground
            }
        }
    }
    
    @Published @IBInspectable var isLoading: Bool = false {
        didSet {
            updateActivityIndicator()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        if shouldShowUnderline {
            underlineColor = .systemGray
        } else {
            underlineColor = .systemBackground
        }
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        underlineColor = .systemBackground
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    
    func updateUnderline() {
        let line = UIView()
        line.backgroundColor = underlineColor
        addSubview(line)
        let margins = layoutMarginsGuide
        line.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 7).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        line.clipsToBounds = true
        layoutIfNeeded()
        line.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
    private func updateActivityIndicator() {
        self.subviews.forEach { (view) in
            if view.tag == 1000 { view.removeFromSuperview() }
        }
        let indicator = UIActivityIndicatorView()
        indicator.tag = 1000
        if isLoading {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
        
//        indicator.backgroundColor = .red
//        indicator.tintColor = .blue
        indicator.clipsToBounds = true
//        indicator.bounds = CGRect(x: 50, y: 0, width: 30, height: 30)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.style = UIActivityIndicatorView.Style.medium
        addSubview(indicator)
        layoutIfNeeded()
        indicator.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(self.frame.width - 10)
            make.centerY.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
}


@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var underlineHeight: CGFloat = 2 {
        didSet {
            updateUnderline()
        }
    }
    @IBInspectable var underlineColor: UIColor = .gray {
        didSet {
            updateUnderline()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        underlineColor = .systemRed
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        underlineColor = .systemBlue
        layoutIfNeeded()
        return true
    }
    
    private func updateUnderline() {
        let line = UIView()
        line.backgroundColor = underlineColor
        addSubview(line)
        let margins = layoutMarginsGuide
        line.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 7).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        line.clipsToBounds = true
        clipsToBounds = true
        layoutIfNeeded()
        line.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
}
