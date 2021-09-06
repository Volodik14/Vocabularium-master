//
//  AddTagsViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/14/21.
//  Copyright © 2021 ParshakovAlexander. All rights reserved.
//

import UIKit
import Lottie
import IQKeyboardManager

protocol AddTagsDelegate: AnyObject {
    func addTags(tags: [Tag])
    func modalDidDisappear()
}

final class AddTagsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func onAddButtonTouched(_ sender: Any) {
        if searchBar.isFirstResponder {
            let alert = UIAlertController(title: "New Tag", message: "Add a new tag", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Add", style: .default) {
                [unowned self] action in
                
                guard let textField = alert.textFields?.first,
                    let tagToAdd = textField.text else {
                        return
                }
                if self.tagList.filter({ $0.name == tagToAdd}).count == 0 {
                    let tag = Tag(name: tagToAdd, isSelected: true)
                    
//                    NetworkManager.Tags.postTag(tag: tag)
                    self.tagList.append(tag)
                    
                    self.searchBar.text?.removeAll()
                    self.searchBar.resignFirstResponder()
                    self.stackSelectedAbove(inTagArray: &self.tagList)
                    self.tagsTableView.reloadData()
                    self.searchBar.becomeFirstResponder()
                    
                    let index = self.tagList.map({ (tag) -> String in
                        return tag.name
                    }).firstIndex(of: tagToAdd)
                    let cell = self.tagsTableView.cellForRow(at: IndexPath(row: index!, section: 0)) as! AddableTagCell
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
                        Animator.animateLabelColor(firstColor: .systemRed, secondColor: UIColor(named: "FontColor")!, label: cell.nameLabel, additionalScale: 0.1)
                    })
                }
                else {
                    let okAlert = UIAlertController(title: "Tag exists", message: "There is such a tag already", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) {
                        [unowned self] action in
                        self.present(alert, animated: true)
                    }
                    
                    okAlert.addAction(okAction)
                    self.present(okAlert, animated: false)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                [unowned self] action in
                if self.tagList.filter({ $0.name == self.searchBar.text}).count == 0 {
                    self.extendAddButton()
                    self.addButton.isEnabled = true
                }
            }
            
            alert.addTextField { (textfield) in
                textfield.text = self.searchBar.text
            }
            
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
        else {
            self.delegate?.addTags(tags: self.tagList.filter({ $0.isSelected == true }))
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func onCancelButtonTouched(_ sender: Any) {
        if searchBar.isFirstResponder {
            tagTableHeightConstraint.isActive = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.searchBar.resignFirstResponder()
                self.scrollToFirstRow()
            }
            searchBar.text?.removeAll()
            stackSelectedAbove(inTagArray: &self.tagList)
            tagsTableView.reloadData()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var addButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var tagTableHeightConstraint: NSLayoutConstraint!
    var cancelButtonCenterXConstraint: NSLayoutConstraint!
    
    var delegate: AddTagsDelegate?
    var tagList: Array<Tag> = [Tag]()
    var filteredTagList: Array<Tag> = [Tag]()
    var tagsFromMain: Array<Tag> = [Tag]()
    var originalTableHeight: CGFloat = 0
    var timer: Timer?
    
    private var isFiltering: Bool {
        return !searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            setupConforming()
            addObservers()
        }
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        searchBar.placeholder = "Search tags"
//        LottieManager.curtainScreen(animationView: animationView, tableView: tagsTableView)
        loadTags()
        setupTagSelection()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addButtonHeightConstraint.constant = 40
        addButtonWidthConstraint.constant = view.frame.width * 0.4
        cancelButtonHeightConstraint.constant = 40
        cancelButtonWidthConstraint.constant = view.frame.width * 0.4
        
        tagTableHeightConstraint.isActive = false
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.originalTableHeight = self.tagsTableView.frame.height
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.modalDidDisappear()
    }
    
    private func setupConforming() {
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setupButtons() {
        addButton.layer.cornerRadius = 10
        addButton.tintColor = .white
        addButton.isEnabled = false
        addButton.setTitleColor(.red, for: .disabled)
        addButton.setTitleColor(UIColor.white, for: .normal)
        
        
        cancelButton.layer.cornerRadius = 10
    }
    
    private func setupTagSelection() {
        tagsFromMain.forEach({ (tagFromMain) in
            tagList.first(where: { $0.id == tagFromMain.id })?.isSelected = true
        })
        stackSelectedAbove(inTagArray: &tagList)
        tagsTableView.reloadData()
    }
}


extension AddTagsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTagList.count
        }
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTag:Tag
        if isFiltering {
            currentTag = (filteredTagList[indexPath.row])
        }
        else {
            currentTag = (tagList[indexPath.row])
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: AddableTagCell.identifier) as! AddableTagCell
        cell.selectionStyle = .none
        cell.setTag(tag: currentTag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tagsTableView.cellForRow(at: indexPath!) as! AddableTagCell
        
        if let row = tagList.firstIndex(where: {$0.id == currentCell.tagVariable?.id}) {
            let isSelected:Bool = (tagList[row].isSelected)
            tagList[row].isSelected = !isSelected
        }
        changeAddButtonEnabled()
        tagsTableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.none)
    }
    
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if tagsTableView.numberOfRows(inSection: 0) != 0 {
            self.tagsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    private func changeAddButtonEnabled() {
        let initiallySelectedIds = tagsFromMain.map({ $0.id})
        let currentlySelectedIds = tagList
            .filter({ (tag: Tag) -> Bool in
                return tag.isSelected })
            .map({ $0.id })
        
        if initiallySelectedIds != currentlySelectedIds {
            addButton.isEnabled = true
        }
        else {
            addButton.isEnabled = false
        }
    }
}

// MARK: - Getting Data
extension AddTagsViewController {
    
    private func loadTags() {
        tagList = [
            Tag(name: "Advertisement", isSelected: false),
            Tag(name: "Aircraft", isSelected: false),
            Tag(name: "Age", isSelected: false),
            Tag(name: "Animals", isSelected: false),
            Tag(name: "Appearance", isSelected: false),
            Tag(name: "Approval", isSelected: false),
            Tag(name: "Archaic", isSelected: false),
            Tag(name: "Modern World", isSelected: false),
            Tag(name: "Wood", isSelected: false),
            Tag(name: "Worry", isSelected: false)
        ]
    }
    
    private func stackSelectedAbove(inTagArray array: inout [Tag]) {
        let selectedArray = array.filter({ $0.isSelected})
        array = selectedArray + array.filter({ !$0.isSelected})
    }
}

extension AddTagsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.filter(content: searchText)
            if self.searchBar.text!.isEmpty {
                
                self.stackSelectedAbove(inTagArray: &self.tagList)
            }
            self.tagsTableView.reloadData()
            if self.tagList.filter({$0.name == searchBar.text}).count == 0 && searchBar.text != "" {
                self.extendAddButton()
                self.addButton.isEnabled = true
            }
            else if self.tagsTableView.numberOfRows(inSection: 0) != 0 || searchBar.text == "" {
                self.shrinkAddButton()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.filter(content: searchBar.text!)
        self.tagsTableView.reloadData()
    }
    
    private func filter(content: String) {
        let startingWith = tagList.filter({ $0.name.lowercased().hasPrefix(content.lowercased()) })
        let notStartingWithButContaining = tagList.filter({ !$0.name.lowercased().hasPrefix(content.lowercased())
                                                          && $0.name.lowercased().contains(content.lowercased()) })
        filteredTagList = startingWith + notStartingWithButContaining
        tagsTableView.reloadData()
    }
}

// MARK: - Keyboard Moveup Handling

extension AddTagsViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if tagsTableView.frame.height == originalTableHeight {
                tagTableHeightConstraint.isActive = true
                tagTableHeightConstraint.constant = tagsTableView.frame.height - keyboardSize.height + 30
                cancelButton.setTitle("Done", for: .normal)
                addButton.setTitle("Create tag", for: .normal)
                cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                
                cancelButtonCenterXConstraint = cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                shrinkAddButton()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tagTableHeightConstraint.isActive = false
        extendAddButton()
        cancelButton.setTitle("Cancel", for: .normal)
        addButton.setTitle("Ready", for: .normal)
    }
    
    private func shrinkAddButton() {
        cancelButtonCenterXConstraint.isActive = true
        addButtonWidthConstraint.constant = 0
        addButton.clipsToBounds = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func extendAddButton() {
        cancelButtonCenterXConstraint.isActive = false
        cancelButtonWidthConstraint.constant = view.frame.width * 0.4
        addButtonWidthConstraint.constant = view.frame.width * 0.4
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
