//
//  TagPanel.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/13/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

//import struct DictionaryAPI.Tag
import UIKit
import TagListView

final class TagPanel: UIView, NibLoadable {
    
    @IBOutlet private var tagLabel: UILabel!
    @IBOutlet private var tagListView: TagListView!
    @IBOutlet private var separator: UIView!
    @IBOutlet private var addButton: UIButton!
    
    static func make(tags: [Tag]?) -> TagPanel {
        let tagPanel = TagPanel.loadFromNib()
        
        tagPanel.backgroundColor = .none
        tagPanel.tagListView.textFont = UIFont.systemFont(ofSize: 18)
        tagPanel.tagListView.alignment = .left
        
        if let tags = tags {
            tagPanel.tagListView.addTags(tags.map { $0.name } )
        }
        
        return tagPanel
    }
}

