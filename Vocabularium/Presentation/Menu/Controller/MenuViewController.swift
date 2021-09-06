//
//  MenuViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/3/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import Foundation

final class MenuTableViewController: UITableViewController {
    
    @IBOutlet private var myDictionaryRow: UIView!
    @IBOutlet private var learnVocabularyRow: UIView!
    @IBOutlet private var settingsVocabularyRow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRows()
        selectDictionaryPage()
    }
    
    
    // MARK: - Private Methods
    
    private func setupRows() {
        tableView.separatorColor = .clear
        myDictionaryRow.layer.cornerRadius = 10
        myDictionaryRow.setSlightShadow()
        
        learnVocabularyRow.layer.cornerRadius = 10
        learnVocabularyRow.setSlightShadow()
        
        settingsVocabularyRow.layer.cornerRadius = 10
        settingsVocabularyRow.setSlightShadow()
    }
    
    private func selectDictionaryPage() {
        let homeIndexPath = IndexPath(item: MainMenuRow.myDictionary.index, section: 0)
        self.tableView.selectRow(at: homeIndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
        self.highlight(.main(row: .myDictionary))
    }
    
    private func highlight(_ menuSection: MenuSection) {
        UIView.animate(withDuration: 0.1) { [ weak self] in
            
            switch menuSection {
            case .main(let mainRow):
                switch mainRow {
                case .myDictionary:
                    self?.myDictionaryRow.backgroundColor = .systemBlue
                    self?.learnVocabularyRow.backgroundColor = .white
                    self?.settingsVocabularyRow.backgroundColor = .white
                case .learnVocabulary:
                    self?.myDictionaryRow.backgroundColor = .white
                    self?.learnVocabularyRow.backgroundColor = .systemBlue
                    self?.settingsVocabularyRow.backgroundColor = .white
                default:
                    break
                }
            case .settings(_):
                self?.myDictionaryRow.backgroundColor = .white
                self?.learnVocabularyRow.backgroundColor = .white
                self?.settingsVocabularyRow.backgroundColor = .systemBlue
                break
            case .exit(_):
                break
            }
        }
    }
}

extension MenuTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return MainMenuRow.allCases.count }
        else if section == 1 {return SettingsMenuRow.allCases.count }
        else if section == 2 { return ExitMenuRow.allCases.count }
        else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(.from(indexPath: indexPath))
        highlight(.from(indexPath: indexPath))
    }
    
    private func push(_ menuSection: MenuSection) {
        switch menuSection {
        case .main(let mainRow):
            mainRow.push(from: self)
        case .settings(let settingsRow):
            settingsRow.push(from: self)
        default:
            break
        }
    }
}
