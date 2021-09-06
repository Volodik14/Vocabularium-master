//
//  DictionaryHeaderView.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/30/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import UIKit

class DictionaryHeaderView: UICollectionReusableView {
    // MARK: - Outlets
//    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var totalWrapperView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setUI() {
//        backgroundView.backgroundColor = UIColor.orange.withAlphaComponent(1)
//        backgroundView.layer.cornerRadius = 20
//        totalWrapperView.layer.cornerRadius = 10
//        layoutIfNeeded()
    }
    
    func setTotalLabel(withNumber number: Int) {
        totalLabel.text = "Total: \(number)"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
