//
//  ChooseGameViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/18/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class ChooseGameViewController: ScrollableViewController {
    
    private let matchGameSelectableView = MatchGameSelectableView.make()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.becomeTransparent()
        
        
        
        
        let gameButton = UIButton()
        gameButton.backgroundColor = .white
        gameButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        gameButton.setTitle("Learning game", for: .normal)
        gameButton.setTitleColor(.black, for: .normal)
        gameButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        gameButton.layer.cornerRadius = 15
        gameButton.setSlightShadow(length: 4)
        
        scrollView.addSubview(gameButton)
        
        
        //scrollView.addSubview(matchGameSelectableView)
        
        gameButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).inset(20)
            make.height.equalTo(250)
        }
        
        
    }
    
    @objc func pressed() {
        if #available(iOS 13.0, *) {
            navigationController?.hero.isEnabled = true
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date1 = formatter.date(from: "2021-07-21")
            
            let learningView = LearningView(cards: cards, count: cards.count, maxCount: cards.count, startDate: date1!, endDate: Date())
            //let backButton = UIBarButtonItem()
            //backButton.image = UIImage.init(systemName: "chevron.down")
            let hostVC = UIHostingController(rootView: learningView)
            navigationController?.navigationItem.leftBarButtonItem?.image = UIImage.init(systemName: "chevron.down")
            navigationController?.pushViewController(hostVC, animated: true)
        }
    }
}
