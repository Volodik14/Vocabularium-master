//
//  Constants.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation


struct Constants {
    private init() {}
    
    struct Colors {
        private init() {}
        
        struct CGGradientSets {
            private init() {}
            
            static let amin = Constants.Colors.UIGradientSets.amin.map { $0.cgColor }
            static let stellar = Constants.Colors.UIGradientSets.stellar.map { $0.cgColor }
            static let rainbowBlue = Constants.Colors.UIGradientSets.rainbowBlue.map { $0.cgColor }
            static let deepSpace = Constants.Colors.UIGradientSets.deepSpace.map { $0.cgColor }
            static let zinc = Constants.Colors.UIGradientSets.zinc.map { $0.cgColor }
        }
        struct UIGradientSets {
            private init() {}
            
            static let amin = [hexStringToUIColor(hex: "#4A00E0"), hexStringToUIColor(hex: "#8E2DE2")]
            static let stellar = [hexStringToUIColor(hex: "#7474BF"), hexStringToUIColor(hex: "#348AC7")]
            static let rainbowBlue = [hexStringToUIColor(hex: "#00F260"), hexStringToUIColor(hex: "#0575E6")]
            static let deepSpace = [hexStringToUIColor(hex: "#000000"), hexStringToUIColor(hex: "#434343")]
            static let zinc = [hexStringToUIColor(hex: "#ADA996"), hexStringToUIColor(hex: "#F2F2F2"), hexStringToUIColor(hex: "#DBDBDB"), hexStringToUIColor(hex: "#EAEAEA")]
        }
        
        struct Statics {
            private init() {}

            static let accentColor = Constants.Colors.hexStringToUIColor(hex: "#5306E0")
        }
        
    }
    
    struct UIConfiguration {
        private init() {}
        
        struct StaticSizes {
            private init() {}
            
            static let basicAddTermButtonWidth = 55
        }
        
        struct ComputedSizes {
            private init() {}
            
            struct Font {
            private init() {}
                
                static var dictionaryTerm = collectionCellHeight * 0.168
                static var dictionaryMeaning = collectionCellHeight * 0.092
            }
            private static let screenSize = UIScreen.main.bounds.size
            private static let collectionHeightWithoutHeader = (screenSize.height - collectionHeaderHeight)
            
            
            static var collectionHeaderHeight: CGFloat {
                switch UIDevice().type {
                case .iPhone8:
                    return UIScreen.main.bounds.size.height * 0.36
                case .iPhone11:
                    return UIScreen.main.bounds.size.height * 0.38
                default:
                    return UIScreen.main.bounds.size.height * 0.38
                }
            }
            
            static var collectionCellWidth: CGFloat {
                switch UIDevice().type {
                case .iPhone8:
                    return screenSize.width * 0.78
                case .iPhone11:
                    return screenSize.width * 0.85
                default:
                    return screenSize.width * 0.85
                }
            }
            
            static var collectionCellHeight: CGFloat {
                switch UIDevice().type {
                case .iPhone8:
                    return collectionHeightWithoutHeader * 0.3
                case .iPhone11:
                    return collectionHeightWithoutHeader * 0.3
                default:
                    return collectionHeightWithoutHeader * 0.3
                }
            }
            
        }
    }
    
    
    struct IDs {
        private init() {}
        
        struct EntryKit {
            private init() {}
            
            static let qrSuccessAlert = "qrSucessAlert"
        }
        
        struct Hero {
            private init() {}
            
            static let scanButton = "scanButton"
            static let targetOutline = "targetOutline"
            static let cardOnEdit = "cardOnEdit"
            static let selectedDefinition = "selectedDefinition"
        }
    }
}



extension Constants.Colors {
    
    private static func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
