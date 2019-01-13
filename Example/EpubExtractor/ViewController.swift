//
//  ViewController.swift
//  EpubExtractor
//
//  Created by f-meloni on 02/18/2017.
//  Copyright (c) 2017 f-meloni. All rights reserved.
//

import UIKit
import Foundation
import EpubExtractor

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return epubReader.epubs.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epubReader.epubs[section].1.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        }
        
        cell?.textLabel?.text = epubReader.epubs[indexPath.section].1[indexPath.item]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return epubReader.epubs[section].0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! EpubDetailViewController
        detailVC.epubName = epubReader.epubs[indexPath.section].1[indexPath.item]

        self.navigationController?.show(detailVC, sender: self)
    }
}
