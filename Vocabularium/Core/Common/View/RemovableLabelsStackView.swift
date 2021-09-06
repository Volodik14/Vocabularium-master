//
//  ExampleStackView.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/20/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

protocol RemovableLabelProtocol {
    func removeLabel(withText text: String)
}

final class RemovableLabelsStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        
        removeAllLabels()
        
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.spacing = 30
    }
    
    public func insertLabelBeforeLastView(withText text: String) {
        let removableView = RemovableRow(withText: text, delegate: self)
        self.insertArrangedSubview(removableView, at: self.arrangedSubviews.count - 1)
    }
    
    public func insertLabelsBeforeLastView(withTexts texts: [String]?) {
        guard let texts = texts else { return }
        texts.forEach { (text) in
            let removableView = RemovableRow(withText: text, delegate: self)
            self.insertArrangedSubview(removableView, at: self.arrangedSubviews.count - 1)
        }
    }
    
    public func removeAllLabels() {
        arrangedSubviews.forEach { (view) in
            if (view is RemovableRow) {
                UIView.animate(withDuration: 0.3, animations: {
                    view.isHidden = true
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension RemovableLabelsStackView: RemovableLabelProtocol {
    func removeLabel(withText text: String) {
        if let removableView = self.arrangedSubviews.first(where: { ($0 as! RemovableRow).removableText == text }) {
            UIView.animate(withDuration: 0.3, animations: {
                removableView.isHidden = true
            }) { (_) in
                removableView.removeFromSuperview()
            }
        }
    }
}



final class RemovableRow: UIView {
    
    public var removableText = ""
    private let delegate: RemovableLabelProtocol?
    private var removeButton: UIButton?
    
    init(withText text: String, delegate: RemovableLabelProtocol) {
        self.delegate = delegate
        super.init(frame:.zero)
        
        self.removableText = text
        self.configureRow(text: text)
    }
    
    private func configureRow(text: String) {
        let label = UILabel()
        removeButton = UIButton()
        guard let removeButton = removeButton else { return }
        
        label.text = text
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
        removeButton.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        removeButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        removeButton.tintColor = .lightGray
        removeButton.addTarget(self, action: #selector(askToRemoveSelf), for: .touchUpInside)
        
        self.addSubview(label)
        self.addSubview(removeButton)
        
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(removeButton.snp.leading).offset(10)
        }
        removeButton.snp.makeConstraints { (make) in
            make.width.equalTo(55)
            make.height.equalTo(55)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.snp.trailing).offset(5)
        }
    }
    
    @objc
    private func askToRemoveSelf() {
        removeButton?.removeFromSuperview()
        delegate?.removeLabel(withText: self.removableText)
    }
    
    required init?(coder: NSCoder) {
        delegate = nil
        super.init(coder: coder)
    }
}
