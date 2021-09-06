//
//  CancelConfirmViewController.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 8/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import UIKit
import SnapKit

class ModalTableViewController: UITableViewController {
    
    var cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCancelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.bringSubviewToFront(cancelButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cancelButton.snp.remakeConstraints { (remake) in
            remake.width.equalTo(50)
            remake.height.equalTo(50)
            remake.right.equalTo(view.superview!.snp.right).inset(50)
            remake.bottom.equalTo(view.superview!.snp.bottom).offset(-50)
        }
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addCancelButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 10
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        cancelButton.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
        cancelButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        cancelButton.tintColor = .black
        cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.equalTo(view.snp.left).offset(view.frame.size.width - 50)
            make.bottom.equalTo(view.snp.bottom).offset(view.frame.size.height + 70)
        }
        view.layoutIfNeeded()
        cancelButton.setSlightShadow(length: 6)
    }
    
    @objc
    private func closeView() {
        self.dismiss(animated: true)
    }
}
