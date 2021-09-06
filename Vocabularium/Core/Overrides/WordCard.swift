//
//  WordCard.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/23/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

enum CardState {
    case centeredInitially
    case anchoredToTop
    case centeredWhileEditing
}

final class WordCard: UIView {
    var topConstraintState: CardState = .centeredInitially
    var lastSubtractableHeight: CGFloat = 0
    
    func changeTopConstraintState(to state: CardState) {
        if let topConstraint = self.superview?.constraints.first(where: { $0.identifier == "StateableTopConstraint" }) {
            switch state {
            case .anchoredToTop:
                topConstraint.constant = 30
            default:
                topConstraint.constant = 200
            }
            self.topConstraintState = state
        }
    }
    
    func changeTopConstraintState(to state: CardState, withSubtractableHeight subtractableHeight: CGFloat, inViewController viewController: UIViewController, contentOffsetY: CGFloat) {
        if let topConstraint = self.superview?.constraints.first(where: { $0.identifier == "StateableTopConstraint" }) {
            let safeAreaHeight = UIApplication.shared.statusBarFrame.height + viewController.navigationController!.navigationBar.frame.height
            switch state {
            case .anchoredToTop:
                topConstraint.constant = 30
            default:
                topConstraint.constant = viewController.view.frame.height - subtractableHeight - safeAreaHeight - self.frame.height + contentOffsetY
            }
            self.lastSubtractableHeight = subtractableHeight
            self.topConstraintState = state
        }
    }
}
