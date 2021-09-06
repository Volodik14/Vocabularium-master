//
//  MatchGameSelectableView.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/18/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import Foundation

final class MatchGameSelectableView: UIView, NibLoadable {
    
    @IBOutlet private var islandView: UIView!
    @IBOutlet private var upperHorizontalStackView: UIStackView!
    @IBOutlet private var lowerHorizontalStackView: UIStackView!
    @IBOutlet private var labelContainerView: UIView!
    
    static func make() -> MatchGameSelectableView {
        let view = MatchGameSelectableView.loadFromNib()
        
        view.setSlightShadow()
        view.islandView.setSlightShadow()
        view.labelContainerView.setSlightShadow()
        view.upperHorizontalStackView.arrangedSubviews.forEach { $0.setSlightShadow() }
        view.lowerHorizontalStackView.arrangedSubviews.forEach { $0.setSlightShadow() }
        
        view.islandView.backgroundColor = .white
        view.labelContainerView.backgroundColor = .white
        view.upperHorizontalStackView.backgroundColor = .none
        view.lowerHorizontalStackView.backgroundColor = .none
        
        return view
    }
    
}
