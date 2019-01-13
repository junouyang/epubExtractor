//
//  Epub2ChapterItem.swift
//  Pods
//
//  Created by Franco Meloni on 17/04/2017.
//
//

import UIKit
import AEXML

struct Epub2ChapterItem: ChapterItem {
    let id: String
    let playOrder: Int
    let uniqueSrc: String
    let src: URL
    let label: String?
    let subChapters: [ChapterItem]
    let bookmark: String?
    
    init?(xmlElement: AEXMLElement, epubContentsURL: URL) {
        guard let id = xmlElement.attributes["id"],
            let playOrderString = xmlElement.attributes["playOrder"],
            let playOrder = Int(playOrderString),
            let srcString = xmlElement["content"].attributes["src"] else {
            return nil
        }
        
        self.id = id
        self.playOrder = playOrder
        self.uniqueSrc = srcString
        let splitArray: [String.SubSequence] = srcString.split(separator: "#")
        self.src = epubContentsURL.appendingPathComponent(String(splitArray[0]))
        if splitArray.count > 1 {
            self.bookmark = String(splitArray[1])
        } else {
            self.bookmark = nil
        }
        self.label = xmlElement["navLabel"]["text"].value
        
        var subChapters: [Epub2ChapterItem] = []
        
        for subChapterElement in xmlElement["navPoint"].all ?? [] {
            if let subChapter = Epub2ChapterItem(xmlElement: subChapterElement, epubContentsURL: epubContentsURL) {
                subChapters.append(subChapter)
            }
        }
    
        subChapters.sort { $0.playOrder < $1.playOrder }
        
        self.subChapters = subChapters
    }
}
