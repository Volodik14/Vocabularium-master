//
//  ViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import UIKit
import SnapKit
import SwiftUI

class DictionaryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: - Code UI
    
    
    // MARK: - Variables
    var termList: [Term] = []
    var cellHeightWithSpacing: CGFloat = 0
    var firstLoad = true
    
    var searchButton: UIButton? {
        var searchButton: UIButton? = nil
        for subview in view.subviews {
            if subview.tag == 2002 {
                searchButton = subview as? UIButton
                break
            }
        }
        return searchButton
    }
    
    // MARK: - Aliases
    typealias ComputedSizes = Constants.UIConfiguration.ComputedSizes
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.becomeTransparent()
        navigationController?.navigationBar.hero.id = "MenuButton"
        
        setupRevealBehaviour(forButton: menuButton)
        tie(to: collectionView)
        
        prepateInsets()
        addCreateButton()
        addSearchButton()
        createButton?.addTarget(self, action: #selector(goToAddTerm), for: .touchUpInside)
        searchButton?.addTarget(self, action: #selector(goToSearchTerms), for: .touchUpInside)
        fetchMockData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCreateButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            collectionView.offsetToCenter(view: view)
            firstLoad = false
        }
        
        createButton?.setImage(UIImage(systemName: "plus"), for: .normal)
        if Int(createButton?.frame.width ?? 0) != Constants.UIConfiguration.StaticSizes.basicAddTermButtonWidth {
            createButton?.setTitle("Add term", for: .normal)
        }
    }
    
    
    // MARK: - Actions
    @objc func goToAddTerm() {
        navigationController?.hero.isEnabled = true
        createButton?.setImage(nil, for: .normal)
        createButton?.setTitle("", for: .normal)
        let mainStoryboard = UIStoryboard(name: "AddTerm", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AddTermNavigationController") as? UINavigationController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.view.hero.id = "AddTermMain"
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func goToSearchTerms() {
        if #available(iOS 13.0, *) {
            navigationController?.hero.isEnabled = true
            let searchView = SearchView(cards: cards)
            let hostVC = UIHostingController(rootView: searchView)
            hostVC.navigationController?.becomeTransparent()
            navigationController?.pushViewController(hostVC, animated: true)
        }
    }
    
    // MARK: Private Methods
    
    private func setupCreateButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        createButton?.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
    }
}


// MARK: - UICollection
extension DictionaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        termList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentTerm = termList[indexPath.row]
        let termCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TermCollectionViewCell", for: indexPath) as! TermCollectionViewCell
        termCell.setTerm(with: currentTerm)

//        movieCell.thumbnailImage.hero.id = "MoviePoster \(currentMovie.id)"
//        movieCell.titleWrapperView.hero.id = "TitleWrapper \(currentMovie.id)"
//        movieCell.titleLabel.hero.id = "TitleLabel \(currentMovie.id)"
//        movieCell.bottomTransformerView.hero.id = "BottomTransformerView \(currentMovie.id)"
        
        return termCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DictionaryHeaderView", for: indexPath) as! DictionaryHeaderView
        header.setUI()
        header.setTotalLabel(withNumber: termList.count)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.contentInsetAdjustmentBehavior = .automatic
        let previousPath = IndexPath(item: indexPath.item - 1, section: 0)
        if previousPath.item != -1 {
            collectionView.scrollToItem(at: previousPath, at: .centeredVertically, animated: true)
        } else {
            var newOffset = collectionView.contentOffset

            let index = (newOffset.y + collectionView.adjustedContentInset.top) / cellHeightWithSpacing
            let roundedIndex = round(index)
            if roundedIndex == 1 {
                newOffset.y -= cellHeightWithSpacing
            } else if roundedIndex == 2 {
                newOffset.y -= cellHeightWithSpacing * 2
            }
            collectionView.setContentOffset(newOffset, animated: true)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension DictionaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width * 0.8, height: ComputedSizes.collectionHeaderHeight)
    }
}


// MARK: - UIScrollViewDelegate
extension DictionaryViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var layout = UICollectionViewFlowLayout()
        if (scrollView as? UICollectionView) == collectionView {
            layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        }
        cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.y + scrollView.adjustedContentInset.top) / cellHeightWithSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: scrollView.adjustedContentInset.left, y: roundedIndex * cellHeightWithSpacing - scrollView.adjustedContentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.transformAndFade(forCollectionView: collectionView)
        
        if collectionView.isLastCellVisible(forList: termList) {
            if createButton?.currentTitle?.count ?? 0 == 0 {
                centerCreateButton()
            }
        } else {
            if createButton?.currentTitle?.count ?? 0 > 0 {
                resetCreateButton()
            }
        }
    }
    
    func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.4
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
    }
}


// MARK: - Helper Methods
extension DictionaryViewController {
    private func transformAndFade(forCollectionView collectionView: UICollectionView) {
        let centerY = collectionView.center.y
        var layout = UICollectionViewFlowLayout()
        
        layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
        
        for cell in collectionView.visibleCells {
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterY = (basePosition.y + collectionView.frame.size.width / 2.0 ) - cellHeightWithSpacing
            
            let distance = abs(cellCenterY - centerY)
            
            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerY ) * 0.455)
            if (scale > 1.0) {
                scale = 1.0
            }
            
            if(scale < 0.860091) {
                scale = 0.860091
            }
            
            cell.transformToScale(scale)
            
            if collectionView == collectionView {
                let coverCell = cell as! TermCollectionViewCell
                coverCell.wrapperView.alpha = changeSizeScaleToAlphaScale(scale)
            }
        }
    }
}


// MARK: - Build UI
extension DictionaryViewController {
    private func prepateInsets() {
        let cellHeight = ComputedSizes.collectionCellHeight
        let cellWidth: CGFloat = ComputedSizes.collectionCellWidth
        let insetX: CGFloat = -20.0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: ComputedSizes.collectionCellHeight*2, right: insetX)
    }
    
    private func centerCreateButton() {
        createButton?.setTitleColor(.black, for: .normal)
        createButton?.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        createButton?.titleLabel?.alpha = 0
        createButton?.contentVerticalAlignment = .center
        createButton?.setTitle("Add term", for: .normal)
        createButton?.titleLabel?.textColor = .black
        view.layoutIfNeeded()
        
        createButton?.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(55)
            make.width.equalTo(ComputedSizes.collectionCellWidth - 100)
        })
        
        let spacing: CGFloat = 10
        createButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        createButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.createButton?.titleLabel?.alpha = 1
        }
    }
    
    private func resetCreateButton() {
        createButton?.snp.remakeConstraints { (make) in
            make.right.equalTo(view.snp.right).inset(50)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(55)
            make.width.equalTo(createButton!.snp.height)
        }
        
        let spacing: CGFloat = 0
        createButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        createButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.createButton?.titleLabel?.alpha = 0
            self.createButton?.setTitle("", for: .normal)
        }
    }
}


// MARK: - Data
extension DictionaryViewController {
    func fetchMockData() {
        var term1 = Term()
        term1.content = "Memorandum"
        term1.meaning = "a written message in business or diplomacy"
        var term2 = Term()
        term2.content = "To amble over"
        term2.meaning = "to walk in a slow, leisurely way"
        var term3 = Term()
        term3.content = "A bunch of fives"
        term3.meaning = "a slang term for a fist, especially one used for punching, a slang term for a fist, especially one used for punching"
        var term4 = Term()
        term4.content = "Cacophony"
        term4.meaning = "a harsh, unpleasant mixture of noise"
        var term5 = Term()
        term5.content = "Cognizant"
        term5.meaning = "being aware or having knowledge of something"
        var term6 = Term()
        term6.content = "Corrode"
        term6.meaning = "to gradually wear away"
        var term7 = Term()
        term7.content = "Garbled"
        term7.meaning = "communication that is distorted and unclear"
        termList.append(contentsOf: [term1, term2, term3, term4, term5, term6, term7])
        termList.append(contentsOf: [term1, term2, term3, term4, term5, term6, term7])
        termList.append(contentsOf: [term1, term2, term3, term4, term5, term6, term7])
        termList.append(contentsOf: [term1, term2, term3, term4, term5, term6, term7])
        
        collectionView.reloadData()
    }
}
