//
//  SenseTableViewCell.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

final class SenseTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var examplesLabel: UILabel!
    
    // MARK: - Variables
    var sense: Sense? = nil
    var language: TranslationLanguage = .unknown
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wrapperView.layer.cornerRadius = 15
        
        wrapperView.setSlightShadow()
    }
    
    func set(with sense: Sense) {
        self.sense = sense
        
        if sense.definitions?.count ?? 0 > 0 {
            definitionLabel.text = sense.definitions!.first
            definitionLabel.isHidden = false
        } else {
            definitionLabel.isHidden = true
        }
        
        if sense.examples?.count ?? 0 > 0 {
            examplesLabel.text = sense.examples!.map{ $0.text.capitalizingFirstLetter().quoted(forLang: self.language) }.joined(separator: "\n")
            examplesLabel.isHidden = false
        } else {
            examplesLabel.isHidden = true
        }
    }
}
