//
//  Dictionaries.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class Dictionaries {
    var cet4Words: Set<String>
    var cet6Words: Set<String>
    var greWords: Set<String>
    var elementaryWords: Set<String>
    var middleWords: Set<String>
    var highWords: Set<String>
//    var relations: [String: String]
    var meanings: [String: String]
    
    init() {
        cet4Words = Dictionaries.createDict("cet4")
        cet6Words = Dictionaries.createDict("cet6")
        greWords = Dictionaries.createDict("gre")
        elementaryWords = Dictionaries.createDict("elementary")
        middleWords = Dictionaries.createDict("middle")
        highWords = Dictionaries.createDict("high")
//        relations = Dictionaries.readRelations()
        meanings = Dictionaries.readMeanings()
    }

    class func createDict(_ file: String) -> Set<String> {
        if let path = Bundle.main.url(forResource: "dict/chinese_level/\(file)", withExtension: "txt") {
            do {
                let content = try String(contentsOf: path, encoding: .utf8)
                return Set(content.components(separatedBy: .newlines))
            } catch {
                print(error)
            }
        }
        return Set()
    }
    
    class func readRelations() -> [String: String] {
        var result = [String: String]()
        if let path = Bundle.main.url(forResource: "dict/relations", withExtension: "csv") {
            do {
                let content = try String(contentsOf: path, encoding: .utf8)
                for line in content.components(separatedBy: .newlines) {
                    let relationArray = line.components(separatedBy: ",")
                    if relationArray.count >= 2 {
                        result[relationArray[1]] = relationArray[0]
                    }
                }
            } catch {
                print(error)
            }
        }
        return result
    }

    class func readMeanings() -> [String: String] {
        var result = [String: String]()
        if let path = Bundle.main.url(forResource: "dict/word-meaning", withExtension: "txt") {
            do {
                let content = try String(contentsOf: path, encoding: .utf8)
                for line in content.components(separatedBy: "-----\r\n") {
                    let meaning = line.components(separatedBy: "*****\r\n")
                    if meaning.count >= 3 {
                        result[removeReturns(meaning[0])] = removeReturns(meaning[2])
                    }
                }
            } catch {
                print(error)
            }
        }
        return result
    }
    
    class func removeReturns(_ s: String) -> String {
        return String(s.prefix(s.count - 1))
    }
}

let dictionaries = Dictionaries()
