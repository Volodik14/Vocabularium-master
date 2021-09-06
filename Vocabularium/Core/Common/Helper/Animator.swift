//
//  Animator.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/14/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//


typealias CustomAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class Animator {
    
    private let animation: CustomAnimation
    
    private static var timer: Timer = Timer()
    
    init(animation: @escaping CustomAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell, indexPath, tableView)
        
    }
    
    static func animateLabelColor(firstColor: UIColor, secondColor: UIColor, label: UILabel, additionalScale: Double = 0.05) {
        let changeColor = CATransition()
        changeColor.type = CATransitionType.fade
        changeColor.duration = 0.3
        //        changeColor.startProgress = 0.5
        
        
        CATransaction.setCompletionBlock {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
                label.textColor = secondColor
                label.layer.add(changeColor, forKey: nil)
                UIView.animate(withDuration: 0.3) {
                    label.transform = CGAffineTransform(scaleX: 1, y: 1) //Scale label area
                }
            })
        }
        
        CATransaction.begin()
        label.textColor = firstColor
        label.layer.add(changeColor, forKey: nil)
        UIView.animate(withDuration: 0.3) {
            label.transform = CGAffineTransform(scaleX: CGFloat(1.0 + additionalScale), y: CGFloat(1.0 + additionalScale))
        }
        CATransaction.commit()
    }
}
