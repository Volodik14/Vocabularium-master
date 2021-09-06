//
//  SeparatorStackView.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/20/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

final class BridgeSeparator: UIStackView {
    
    

    init() {
        super.init(frame: .zero)
        
        subviews.forEach { (view) in self.removeArrangedSubview(view) }
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.spacing = 30
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
