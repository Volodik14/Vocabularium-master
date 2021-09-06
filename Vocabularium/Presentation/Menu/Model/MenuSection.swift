//
//  MenuSection.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/3/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//
import SwiftUI
import Foundation

enum MenuSection {
    case main(row: MainMenuRow)
    case settings(row: SettingsMenuRow)
    case exit(row: ExitMenuRow)
    
    static func from(indexPath: IndexPath) -> MenuSection {
        if indexPath.section == 0 {
            return MenuSection.main(row: .allCases.first { $0.index == indexPath.row }!)
        } else if indexPath.section == 1 {
            return .settings(row: .settings)
        } else {
            return .exit(row: .logOut)
        }
    }
}

enum MainMenuRow: CaseIterable {
    case myDictionary
    case learnVocabulary
    case sourceGallery
    case tagGallery
    
    func push(from root: UIViewController) {
        switch self {
        case .myDictionary:
            showMyDictionary(from: root)
        case .learnVocabulary:
            showLearnVocabulary(from: root)
        default:
            break
        }
    }
    
    private func showMyDictionary(from root: UIViewController) {
        let dictionaryController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DictionaryNavigationController") as! UINavigationController
        root.revealViewController()?.pushFrontViewController(dictionaryController, animated: true)
    }
    
    private func showLearnVocabulary(from root: UIViewController) {
        let chooseGameController = ChooseGameViewController()
        let menuButton = UIBarButtonItem()
        menuButton.image = #imageLiteral(resourceName: "iconfinder_menu-alt_134216")
        chooseGameController.navigationItem.leftBarButtonItem = menuButton
        chooseGameController.setupRevealBehaviour(forButton: menuButton)
        
        let gameNavigation = UINavigationController(rootViewController: chooseGameController)
        gameNavigation.navigationController?.becomeTransparent()
        root.revealViewController()?.pushFrontViewController(gameNavigation, animated: true)
    }
    
    
}

enum SettingsMenuRow: CaseIterable {
    case settings
    
    func push(from root: UIViewController) {
        switch self {
        case .settings:
            showSettings(from: root)
        default:
            break
        }
    }
    
    private func showSettings(from root: UIViewController) {
        let filterView = FilterView(sections: sections)
        let hostVC = UIHostingController(rootView: filterView)
        let menuButton = UIBarButtonItem()
        menuButton.image = #imageLiteral(resourceName: "iconfinder_menu-alt_134216")
        hostVC.navigationItem.leftBarButtonItem = menuButton
        hostVC.setupRevealBehaviour(forButton: menuButton)
        
        let hostNavigation = UINavigationController(rootViewController: hostVC)
        root.revealViewController()?.pushFrontViewController(hostNavigation, animated: true)
    }
}

enum ExitMenuRow: CaseIterable {
    case logOut
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index {
        return Self.allCases.firstIndex { self == $0 }!
    }
}
