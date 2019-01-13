//
//  NewWordsController.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

class NewWordsViewController: UIViewController {    
    @IBOutlet weak var tableView: UITableView!
    var newWords: [String]!

    var content: String? {
        didSet {
            if content != nil {
                newWords = parseWords(content!)
            }
        }
    }
    
    func parseWords(_ content: String) -> [String] {
        let words: Set<String> = NatualLanguageProcessor.extractWords(content)
        return words.filter{
            return !dictionaries.elementaryWords.contains($0) &&
                !dictionaries.middleWords.contains($0) &&
                !dictionaries.highWords.contains($0) &&
                !dictionaries.cet4Words.contains($0) &&
                !dictionaries.cet6Words.contains($0)
        }.sorted()
    }
}

extension NewWordsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "New Words"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newWords!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createWordCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func createWordCell(indexPath: IndexPath) -> UITableViewCell {
        let cellId = "WordCell"
        var cell = self.tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text =  self.newWords![indexPath.item]
        return cell!
    }
}
