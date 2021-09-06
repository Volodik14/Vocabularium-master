//
//  UICollectionView+Ext.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation


extension UICollectionView {
    // MARK: - Flow Layout
    func pinFirstItemToCenter(view: UIView) {
        let screenSize = UIScreen.main.bounds.size
        let cellHeight = screenSize.height * Constants.UIConfiguration.ComputedSizes.collectionCellHeight
        let cellWidth: CGFloat = Constants.UIConfiguration.ComputedSizes.collectionCellWidth
        let insetY = (CGFloat(view.bounds.height) - cellHeight) / 2
        let insetX: CGFloat = -20.0
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func offsetToCenter(view: UIView) {
        layoutIfNeeded()
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightWithSpacing = layout.itemSize.height/2 + layout.minimumLineSpacing
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: -cellHeightWithSpacing), animated: false)
    }
    
    
    // MARK: - Cell Visibility
    func isLastCellVisible(forList list: [Any]) -> Bool {
        if list.isEmpty {
            return true
        }

        let lastIndexPath = NSIndexPath(item: list.count - 1, section: 0)
        var cellFrame = self.layoutAttributesForItem(at: lastIndexPath as IndexPath)!.frame

        cellFrame.size.height = cellFrame.size.height

        var cellRect = self.convert(cellFrame, to: self.superview)

        cellRect.origin.y = cellRect.origin.y - cellFrame.size.height - 100
        // substract 100 to make the "visible" area of a cell bigger

        var visibleRect = CGRect(
            x: self.bounds.origin.x,
            y: self.bounds.origin.y,
            width: self.bounds.size.width,
            height: self.bounds.size.height - self.contentInset.bottom
        )

        visibleRect = self.convert(visibleRect, to: self.superview)

        if visibleRect.contains(cellRect) {
            return true
        }

        return false
    }
}
