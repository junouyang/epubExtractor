//
//  EpubReader.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EpubExtractor

class EpubReader {
    let epubs = [("epub 2", ["Adventures of Sherlock Holmes by Arthur Conan Doyle","Metamorphosis-jackson", "A-Room-with-a-View-morrison", "Beyond-Good-and-Evil-Galbraithcolor"]), ("epub3", ["moby-dick", "accessible_epub_3", "cole-voyage-of-life", "spanish-tales-epub3", "igp-epub-unleashed-01-2012", "kje-bible-books"])]
    
    let epubExtractor = EPubExtractor()

}

let epubReader = EpubReader()
