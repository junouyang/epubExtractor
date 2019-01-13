//
//  NaturalLanguageProcessor.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class NatualLanguageProcessor {
    
    static func extractWords(_ text: String) -> Set<String> {
        var words = Set<String>()
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string = text
//        let language = tagger.dominantLanguage
//        print("The language is \(language!)")
        
        let range = NSRange(location: 0, length: text.utf16.count)
//        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
//            let word = (text as NSString).substring(with: tokenRange)
//            print(word)
//        }
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
                words.insert(lemma)
            }
        }
        
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                words.remove(name)
            }
//            var names = Set(["i", "louisiana", "donna", "sherlock", "mary", "thursday", "gesellschaft", "mademoiselle", "august", "german"])
//                let name = (text as NSString).substring(with: tokenRange)
//                if names.contains(name.lowercased()) {
//                    names.remove(name.lowercased())
//                }
        }

        return words
    }
    
    class func test() {
        let quote = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do. - Steve Jobs (Founder of Apple Inc.)"
        print(extractWords(quote))
    }
}

//let natualLanguageProcessor = NatualLanguageProcessor()
