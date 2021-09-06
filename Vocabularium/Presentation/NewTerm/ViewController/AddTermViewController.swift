//
//  AddTermViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 7/1/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import UIKit
import Hero
import Combine

final class AddTermViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var closeButton: UIBarButtonItem!
    @IBOutlet private var cardView: WordCard!
    @IBOutlet private var languageButton: UIButton!
    @IBOutlet private var contentTextView: InputField!
    @IBOutlet private var meaningTextView: InputField!
    @IBOutlet private var fromCardSeparator: UIView!
    @IBOutlet private var examplesAndNoteWrapperView: UIView!
    @IBOutlet private var examplesLabel: UILabel!
    @IBOutlet private var examplesStackView: RemovableLabelsStackView!
    @IBOutlet private var examplesAndNoteSeparator: UIView!
    @IBOutlet private var noteLabel: UILabel!
    @IBOutlet private var noteTextView: InputField!
    @IBOutlet private var fromNoteSeparator: UIView!
    @IBOutlet private var sourceWrapperView: UIView!
    @IBOutlet private var sourceLabel: UILabel!
    @IBOutlet private var fromSourceSeparator: UIView!
    @IBOutlet private var tagPanelContainer: UIView!
    
    
    
    
    // MARK: - Constraints
    @IBOutlet private var cardTopConstraint: NSLayoutConstraint!
    @IBOutlet private var contentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var meaningTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var fromCardSeparatorHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    private var activeTextView = UITextView()
    private var languagePickerView = UIPickerView()
    private var selectedPickerRowView: UIView?
    private var oldPickerRowView: UIView?
    private var searchButton = UIButton()
    
    private var timer: Timer?
    private var entriesResult: [EntriesResult]?
    private var currentLanguage: TranslationLanguage = .americanEnglish
    private var currentTerm = Term()
    private var hasChosenDefinition = false
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.becomeTransparent()
        
        setupCardView()
        setupTapRecognizers()
        setupLanguagePickerView()
        setupSearchButton()
        
        defaultStates()
        
        setCardElementsVisibility(hidden: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
            if self.activeTextView.text.count == 0 {
                _ = self.contentTextView.becomeFirstResponder()
            }
            if self.hasChosenDefinition {
                self.fillDefinitionAndExamples()
            }
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.cardView.transformToIdentity()
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.setCardElementsVisibility(hidden: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChooseDefinitionTableViewController {
            guard let vc = segue.destination as? ChooseDefinitionTableViewController else { return }
            guard let entriesArray = self.entriesResult else { return }
            vc.delegate = self
            vc.language = currentLanguage
            vc.resultArray = entriesArray
            activeTextView.resignFirstResponder()
        }
    }
    
    // MARK: - Actions
    @IBAction func selectLanguageAction(_ sender: Any) {
        languagePickerView.selectRow(TranslationLanguage.allCasesSorted.firstIndex(of: currentLanguage)!, inComponent: 0, animated: false)
        setLanguagePickerVisibility(hidden: false, animated: true)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        activeTextView.resignFirstResponder()
        
        setLanguagePickerVisibility(hidden: true, animated: true)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.setCardElementsVisibility(hidden: true)
            self.setExamplesAndNoteElementsVisibility(hidden: true)
            self.closeButton.tintColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.fromCardSeparator.alpha = 0
                self.fromNoteSeparator.alpha = 0
                self.examplesAndNoteWrapperView.transformToScale(0.001)
                self.sourceWrapperView.transformToScale(0.001)
                self.cardView.transformToScale(0.001)
            }) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismissAll() {
        activeTextView.resignFirstResponder()
        
        if hasChosenDefinition {
            cardView.changeTopConstraintState(to: .anchoredToTop)
        }
        setLanguagePickerVisibility(hidden: true, animated: true)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func searchDefinitions() {
        searchButton.showAnimatedPress()
        guard contentTextView.text.count > 0 else { return }
        self.contentTextView.isLoading = true
        self.loadDefinitions()
    }
    
    // MARK: - Setup Functions
    private func setupCardView() {
        cardView.setSlightShadow()
        cardView.transformToScale(10)
        cardView.backgroundColor = .systemBackground
        cardView.hero.id = Constants.IDs.Hero.cardOnEdit
        
        contentTextView.placeholderLabel.text = "term or concept"
        contentTextView.delegate = self
        
        meaningTextView.placeholderLabel.text = "definition"
        meaningTextView.delegate = self
        meaningTextView.shouldShowUnderline = false
        meaningTextView.underlineColor = .clear
        meaningTextView.hero.id = Constants.IDs.Hero.selectedDefinition
        
        languageButton.setTitle(currentLanguage.fullname, for: .normal)
    }
    
    private func setupExamplesView() {
        examplesAndNoteWrapperView.setSlightShadow()
        noteTextView.placeholderLabel.text = "examples"
        noteTextView.delegate = self
        noteTextView.shouldShowUnderline = false
        noteTextView.underlineColor = .clear
    }
    
    private func defaultStates() {
        activeTextView = contentTextView
        
        examplesAndNoteWrapperView.alpha = 0
        sourceWrapperView.alpha = 0
        tagPanelContainer.alpha = 0
        fromCardSeparator.transformToScale(0.01)
        fromNoteSeparator.transformToScale(0.01)
        fromSourceSeparator.transformToScale(0.01)
        cardView.changeTopConstraintState(to: .centeredInitially)
        view.layoutIfNeeded()
    }
    
    private func setupLanguagePickerView() {
        languagePickerView.layer.cornerRadius = 20
        languagePickerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        languagePickerView.setSlightShadow()
        tie(to: languagePickerView)
        
        view.addSubview(languagePickerView)
        setLanguagePickerVisibility(hidden: true, animated: false)
    }
    
    private func setupSourceView() {
        sourceWrapperView.layer.cornerRadius = sourceWrapperView.frame.height / 2
        sourceWrapperView.setSlightShadow()
    }
    
    private func setupTagPanel() {
        tagPanelContainer.subviews.forEach( { $0.removeFromSuperview() })
        
        let tagPanel = TagPanel.make(tags: currentTerm.tags)
        tagPanelContainer.addSubview(tagPanel)
        tagPanel.pin(to: tagPanelContainer)
        
        tagPanelContainer.backgroundColor = .white
        tagPanelContainer.layer.cornerRadius = 20
        tagPanelContainer.setSlightShadow()
    }
    
    private func setupTapRecognizers() {
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissAll))
        tapOnView.delegate = self
        tapOnView.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnView)
    }
    
    private func setupSearchButton() {
        searchButton.backgroundColor = .none
        searchButton.isEnabled = false
        searchButton.setTitleColor(.label, for: .normal)
        searchButton.setTitle("Choose definition", for: .normal)
        searchButton.setTitleColor(.lightGray, for: .disabled)
        searchButton.addTarget(self, action: #selector(searchDefinitions), for: .touchUpInside)
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(500)
            make.height.equalTo(50)
            make.width.equalTo(sourceWrapperView.snp.width)
            make.centerX.equalTo(view)
        }
        searchButton.layoutIfNeeded()
        searchButton.layer.cornerRadius = searchButton.frame.height / 2
        searchButton.applyGradient(withColor: .stellar, cornerRadius: searchButton.layer.cornerRadius)
    }
    
    private func setCardElementsVisibility(hidden: Bool) {
        contentTextView.alpha = hidden ? 0 : 1
        meaningTextView.alpha = hidden ? 0 : 1
        languageButton.alpha = hidden ? 0 : 1
    }
    
    private func setExamplesAndNoteVisibility(hidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) {
                if hidden {
                    self.fromCardSeparator.transformToScale(0.01)
                } else {
                    self.fromCardSeparator.transformToIdentity()
                }
                self.examplesAndNoteWrapperView.alpha = hidden ? 0 : 1
                self.view.layoutIfNeeded()
            }
        } else {
            if hidden {
                self.fromCardSeparator.transformToScale(0.01)
            } else {
                self.fromCardSeparator.transformToIdentity()
            }
            examplesAndNoteWrapperView.alpha = hidden ? 0 : 1
            view.layoutIfNeeded()
        }
    }
    
    private func setExamplesAndNoteElementsVisibility(hidden: Bool) {
        examplesLabel.alpha = hidden ? 0 : 1
        examplesStackView.alpha = hidden ? 0 : 1
        examplesAndNoteSeparator.alpha = hidden ? 0 : 1
        noteLabel.alpha = hidden ? 0 : 1
        noteTextView.alpha = hidden ? 0 : 1
    }
    
    private func setSourceViewVisibility(hidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) {
                if hidden {
                    self.fromNoteSeparator.transformToScale(0.01)
                } else {
                    self.fromNoteSeparator.transformToIdentity()
                }
                self.sourceWrapperView.alpha = hidden ? 0 : 1
                self.view.layoutIfNeeded()
            }
        } else {
            if hidden {
                self.fromNoteSeparator.transformToScale(0.01)
            } else {
                self.fromNoteSeparator.transformToIdentity()
            }
            sourceWrapperView.alpha = hidden ? 0 : 1
            view.layoutIfNeeded(); return
            
        }
    }
    
    private func setTagPanelVisibility(hidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) {
                if hidden {
                    self.fromSourceSeparator.transformToScale(0.01)
                } else {
                    self.fromSourceSeparator.transformToIdentity()
                }
                self.tagPanelContainer.alpha = hidden ? 0 : 1
                self.view.layoutIfNeeded()
            }
        } else {
            if hidden {
                self.fromSourceSeparator.transformToScale(0.01)
            } else {
                self.fromSourceSeparator.transformToIdentity()
            }
            tagPanelContainer.alpha = hidden ? 0 : 1
            view.layoutIfNeeded(); return
            
        }
    }
    
    private func setLanguagePickerVisibility(hidden: Bool, animated: Bool) {
        languagePickerView.snp.remakeConstraints { (remake) in
            remake.bottom.equalTo(view.snp.bottom).offset(hidden ? 300 : 0)
            remake.right.equalTo(view.snp.right)
            remake.left.equalTo(view.snp.left)
            remake.height.equalTo(300)
        }
        
        guard animated else { view.layoutIfNeeded(); return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeTextView = textView
        
        return true;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setLanguagePickerVisibility(hidden: true, animated: true)
        
        if (textView == contentTextView || textView == meaningTextView) && cardView.topConstraintState == .centeredWhileEditing {
            setExamplesAndNoteVisibility(hidden: true, animated: false)
            //            setSourceViewVisibility(hidden: true, animated: false)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        var heightDifference: CGFloat = 0
        
        if textView == contentTextView {
            heightDifference = estimatedSize.height - contentTextViewHeightConstraint.constant
            contentTextViewHeightConstraint.constant = estimatedSize.height
            contentTextView.placeholderLabel.isHidden = !textView.text.isEmpty
            searchButton.isEnabled = !textView.text.isEmpty
        } else if textView == meaningTextView {
            heightDifference = estimatedSize.height - meaningTextViewHeightConstraint.constant
            meaningTextViewHeightConstraint.constant = estimatedSize.height
            meaningTextView.placeholderLabel.isHidden = !textView.text.isEmpty
        }
        
        if contentTextView.text != currentTerm.content {
            UIView.transition(with: searchButton, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.searchButton.setTitle("Choose definition", for: .normal)
            }, completion: nil)
        } else if hasChosenDefinition {
            UIView.transition(with: searchButton, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.searchButton.setTitle("Choose another definition", for: .normal)
            }, completion: nil)
        }
        let newOffset = scrollView.contentOffset.y + heightDifference
        let newPoint = CGPoint(x: 0, y: newOffset)
        scrollView.setContentOffset(newPoint, animated: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == contentTextView || textView == meaningTextView) && cardView.topConstraintState == .anchoredToTop && hasChosenDefinition {
            setExamplesAndNoteVisibility(hidden: false, animated: false)
        }
    }
    
    private func loadDefinitions() {
        OxfordDictionaryService.EntriesEndpoint.getFields(forWord: contentTextView.text, inLanguage: self.currentLanguage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entriesResult):
                self.entriesResult = entriesResult.results
                self.performSegue(withIdentifier: "goToDefinition", sender: self)
                self.setExamplesAndNoteVisibility(hidden: true, animated: false)
                self.setSourceViewVisibility(hidden: true, animated: false)
                self.setTagPanelVisibility(hidden: true, animated: false)
            case .failure(let error):
                print(error)
            }
            self.contentTextView.isLoading = false
        }
    }
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = TranslationLanguage.allCasesSorted[row].fullname
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        TranslationLanguage.allCasesSorted.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerRowView: UIView
        var pickerLabel: UILabel
        
        if let view = view {
            pickerRowView = view
        } else {
            pickerRowView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
            pickerRowView.layer.cornerRadius = 10
        }
        if oldPickerRowView != nil {
            oldPickerRowView?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            oldPickerRowView?.setNeedsDisplay()
        }
        selectedPickerRowView = pickerView.view(forRow: row, forComponent: component)
        selectedPickerRowView?.backgroundColor = UIColor.white.withAlphaComponent(1)
        selectedPickerRowView?.setNeedsDisplay()
        oldPickerRowView = selectedPickerRowView
        
        pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.label
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = TranslationLanguage.allCasesSorted[row].fullname
        pickerLabel.sizeToFit()
        
        pickerRowView.addSubview(pickerLabel)
        pickerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(pickerRowView)
            make.centerY.equalTo(pickerRowView)
        }
        
        return pickerRowView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLanguage = TranslationLanguage.allCasesSorted[row]
        languageButton.setTitle(currentLanguage.fullname, for: .normal)
    }
}



// MARK: - DefinitionPickerDelegate
extension AddTermViewController: DefinitionPickerDelegate {
    
    func didPickDefinition(definition: String, examples: [String]?) {
        hasChosenDefinition = true
        currentTerm.content = contentTextView.text
        currentTerm.meaning = definition
        meaningTextView.text = currentTerm.meaning
        currentTerm.examples = examples ?? []
        
        searchButton.setTitle("Choose another definition", for: .normal)
    }
    
    private func fillDefinitionAndExamples() {
        setupExamplesView()
        setupSourceView()
        setupTagPanel()
        examplesStackView.removeAllLabels()
        examplesStackView.insertLabelsBeforeLastView(withTexts: currentTerm.examples)
        
        let size = CGSize(width: meaningTextView.frame.width, height: .infinity)
        let estimatedSize = meaningTextView.sizeThatFits(size)
        meaningTextViewHeightConstraint.constant = estimatedSize.height
        meaningTextView.placeholderLabel.isHidden = !meaningTextView.text.isEmpty
        
        cardView.changeTopConstraintState(to: .anchoredToTop)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.fromCardSeparator.transformToIdentity()
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.examplesAndNoteWrapperView.alpha = 1
                    self.setExamplesAndNoteElementsVisibility(hidden: false)
                }) { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.fromNoteSeparator.transformToIdentity()
                    }) { _ in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.sourceWrapperView.alpha = 1
                        }) { _ in
                            UIView.animate(withDuration: 0.3) {
                                self.fromSourceSeparator.transformToIdentity()
                            } completion: { _ in
                                UIView.animate(withDuration: 0.3) {
                                    self.tagPanelContainer.alpha = 1
                                } completion: { _ in
                                    
                                }

                            }

                        }
                    }
                }
            }
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? UIButton { return false }
        return true
    }
}


extension AddTermViewController {
    
    @objc func keyboardWillAppear(notification: NSNotification?) {
        
        guard activeTextView == contentTextView || activeTextView == meaningTextView else { return }
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        let buttonHeight: CGFloat = 50
        let subtractableHeight = keyboardHeight + buttonHeight + 70
        cardView.changeTopConstraintState(to: .centeredWhileEditing, withSubtractableHeight: subtractableHeight, inViewController: self, contentOffsetY: scrollView.contentOffset.y)
        
        searchButton.snp.remakeConstraints { (remake) in
            remake.bottom.equalTo(view.snp.bottom).inset(keyboardHeight + buttonHeight + 5)
            remake.height.equalTo(buttonHeight)
            remake.width.equalTo(sourceWrapperView.snp.width)
            remake.centerX.equalTo(view)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        if hasChosenDefinition {
            cardView.changeTopConstraintState(to: .anchoredToTop)
        } else {
            cardView.changeTopConstraintState(to: .centeredWhileEditing)
        }
        
        searchButton.snp.remakeConstraints { (remake) in
            remake.bottom.equalTo(view.snp.bottom).offset(500)
            remake.height.equalTo(50)
            remake.width.equalTo(sourceWrapperView.snp.width)
            remake.centerX.equalTo(view)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
