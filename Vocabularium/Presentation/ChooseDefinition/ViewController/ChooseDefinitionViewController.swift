//
//  ChooseDefinitionViewController.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

protocol DefinitionPickerDelegate {
    func didPickDefinition(definition: String, examples: [String]?)
}

final class ChooseDefinitionTableViewController: ModalTableViewController {

    // MARK: - Outlets
    @IBOutlet weak var customDefinitionWrapperView: UIView!
    @IBOutlet weak var headerDefinitionsLabel: UILabel!
    @IBOutlet weak var headerLanguageLabel: UILabel!

    // MARK: - Variables
    var resultArray: [EntriesResult] = []
    var language: TranslationLanguage = .unknown

    var timer: Timer?
    var delegate: DefinitionPickerDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeaderView()

        headerDefinitionsLabel.text = resultArray.first?.word.capitalizingFirstLetter()
        headerLanguageLabel.text = "In " + language.fullname
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    private func setupHeaderView() {
        customDefinitionWrapperView.layer.cornerRadius = 10
        customDefinitionWrapperView.setSlightShadow()
        customDefinitionWrapperView.applyGradient(withColor: .stellar, cornerRadius: 10)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeCustomDefinition))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(scaleFooterView))
        longPressRecognizer.minimumPressDuration = 0.3

        customDefinitionWrapperView.addGestureRecognizer(tapRecognizer)
        customDefinitionWrapperView.addGestureRecognizer(longPressRecognizer)
    }

    @objc
    private func scaleFooterView(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            customDefinitionWrapperView.transformToScale(0.9)
        }
        else {
            customDefinitionWrapperView.transformToIdentity()
        }
        UIView.animate(withDuration: 0.4) {
            self.customDefinitionWrapperView.layoutIfNeeded()
        }
    }

    @objc
    private func makeCustomDefinition() {

    }
}

extension ChooseDefinitionTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        resultArray.first?.lexicalEntries.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultArray.first?.lexicalEntries[section].entries.first?.senses.count ?? 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionContainer = UIView()
        let wrapperView = UIView()
        let strikeLine = UIView()
        let headerLabel = UILabel()

        sectionContainer.backgroundColor = .none
        wrapperView.backgroundColor = .white
        wrapperView.layer.cornerRadius = 10
        strikeLine.tag = 1

        sectionContainer.addSubview(wrapperView)
        sectionContainer.addSubview(strikeLine)

        wrapperView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(self.tableView.frame.width * 0.35)
            make.centerX.equalTo(sectionContainer)
            make.centerY.equalTo(sectionContainer)
        }

        strikeLine.snp.makeConstraints { (make) in
            make.height.equalTo(3)
            make.width.equalTo(self.tableView.frame.width)
            make.centerX.equalTo(sectionContainer)
            make.centerY.equalTo(sectionContainer)
        }

        let lexicanEntry = resultArray.first?.lexicalEntries[section]
        headerLabel.text = lexicanEntry?.lexicalCategory.text ?? "" + ": \(lexicanEntry?.entries.first?.senses.count ?? 0)"
        headerLabel.textColor = .secondaryLabel
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        wrapperView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(wrapperView)
            make.centerY.equalTo(wrapperView)
        }

        wrapperView.setSlightShadow()
        sectionContainer.bringSubviewToFront(wrapperView)

        return sectionContainer
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.subviews.forEach { (view) in
            if view.tag == 1 {
                view.backgroundColor = .secondaryLabel
            }
        }

        self.view.bringSubviewToFront(cancelButton)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenseCell", for: indexPath) as! SenseTableViewCell
        guard let lexicalEntry = resultArray.first?.lexicalEntries[indexPath.section] else { return cell }
        let senses = self.getSenseArray(from: lexicalEntry)
        let currentSense = senses[indexPath.row]

        cell.language = self.language
        cell.set(with: currentSense)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SenseTableViewCell
        cell.transformToScale(0.9)

        let definition = cell.definitionLabel.text ?? ""
        let examples = cell.examplesLabel.text?.components(separatedBy: "\n")
        cell.definitionLabel.hero.id = Constants.IDs.Hero.selectedDefinition
        cell.definitionLabel.hero.isEnabled = true
        cell.hero.id = Constants.IDs.Hero.cardOnEdit


        self.hero.isEnabled = true
        self.view.hero.id = Constants.IDs.Hero.scanButton

        dismiss(animated: true) {
            self.delegate?.didPickDefinition(definition: definition, examples: examples)
        }
    }

    private func getSenseArray(from lexicalEntry: LexicalEntry) -> [Sense] {
        guard let senseArray = lexicalEntry.entries.first?.senses else { return [] }

        return senseArray
    }
}
