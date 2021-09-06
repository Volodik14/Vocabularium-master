//
//  TermViewCell.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit

class TermCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    // MARK: - Constraints
    @IBOutlet weak var wrapperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wrapperViewWidthConstraint: NSLayoutConstraint!
    
    
    // MARK: - Aliases
    typealias ComputedSizes = Constants.UIConfiguration.ComputedSizes
    
    
    // MARK: - Variables
    var term = Term()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wrapperView.layer.cornerRadius = 15
        
        wrapperViewHeightConstraint.constant = ComputedSizes.collectionCellHeight
        wrapperViewWidthConstraint.constant = ComputedSizes.collectionCellWidth
        contentLabel.font = UIFont.systemFont(ofSize: ComputedSizes.Font.dictionaryTerm, weight: .regular)
        meaningLabel.font = UIFont.systemFont(ofSize: ComputedSizes.Font.dictionaryMeaning, weight: .regular)
        layoutIfNeeded()
        self.setSlightShadow()
    }
    
    func setTerm(with term: Term) {
        self.term = term
        contentLabel.text = term.content
        meaningLabel.text = term.meaning
    }
}
