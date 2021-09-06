//
//  AddableTagCell.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/14/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import UIKit
import Lottie

final class AddableTagCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = String(describing: self)
    var tagVariable: Tag? = nil
    
    func setTag(tag: Tag) {
        tagVariable = tag
        nameLabel.text = tag.name
        setCheckmark(selected: tag.isSelected)
        
    }
    
    func setCheckmark(selected: Bool) {
        if selected { accessoryType = .checkmark }
        else { accessoryType = .none }
    }
}
