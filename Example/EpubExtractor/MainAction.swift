//
//  MainAction.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

enum MenuAction:String {
    // The name value MUST be "\(action function name):", "preview" is defined in ChapterCell.swift
    case Preview = "preview:"
    
    //We need this awkward little conversion because «enum»'s can only have literals as raw value types. And «Selector»s aren't literal.
    func selector()->Selector{
        return Selector(self.rawValue)
    }
}
