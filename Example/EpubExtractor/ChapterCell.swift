//
//  ChapterCell.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 1/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ChapterCell : UITableViewCell {
    var storyboard: UIStoryboard!
    var navigationController: UINavigationController!
    var content: String!
    
    @objc func preview(_ sender: AnyObject?){
        let newWordsVC = self.storyboard?.instantiateViewController(withIdentifier: "NewWordsVC") as! NewWordsViewController
        newWordsVC.content = self.content
        self.navigationController?.show(newWordsVC, sender: self)
    }
}
