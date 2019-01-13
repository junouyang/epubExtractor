//
//  EpubDetailViewController.swift
//  EpubExtractor_Example
//
//  Created by Franco Meloni on 07/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import EpubExtractor
import SwiftSoup

class EpubDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var chapterContents: [String: String] = [:]

    var epubName: String? {
        didSet {
            epubReader.epubExtractor.delegate = self
            let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let destinationURL = URL(string: destinationPath!)?.appendingPathComponent(epubName!)
            epubReader.epubExtractor.extractEpub(epubURL: Bundle.main.url(forResource: epubName, withExtension: "epub")!, destinationFolder: destinationURL!)
            self.title = epubName
        }
    }
    
    fileprivate var epub: Epub? {
        didSet {
            self.epubPlainChapters = self.generatePlainChapters(chapters: self.epub?.chapters ?? [])
        }
    }
    
    fileprivate var epubPlainChapters: [(chapter: ChapterItem, indentationLevel: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reusableIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generatePlainChapters(chapters: [ChapterItem], currentIndentationLevel: Int = 0) -> [(chapter: ChapterItem, indentationLevel: Int)] {
        return chapters.reduce([], { (result, chapter) -> [(chapter: ChapterItem, indentationLevel: Int)] in
            var result = result
            
            result.append((chapter, currentIndentationLevel))
            
            result.append(contentsOf: self.generatePlainChapters(chapters: chapter.subChapters, currentIndentationLevel: currentIndentationLevel + 1))
            
            return result
        })
    }
}

private let detailSection = 0

private let imageIndex = 0
private let titleIndex = 1
private let authorIndex = 2
private let publisherIndex = 3
private let languageIndex = 4

extension EpubDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == detailSection {
            return 5
        }
        else {
            return self.epubPlainChapters.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == detailSection {
            return "Details"
        }
        else {
            return "Chapters"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == detailSection {
            switch indexPath.item {
            case imageIndex:
                return self.imageCell(indexPath: indexPath)
            case titleIndex:
                return self.titleCell(indexPath: indexPath)
            case authorIndex:
                return self.authorCell(indexPath: indexPath)
            case publisherIndex:
                return self.publisherCell(indexPath: indexPath)
            case languageIndex:
                return self.languageCell(indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        }
        else {
            return chapterCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == detailSection && indexPath.item == imageIndex {
            return 250
        }
        
        return UITableView.automaticDimension
    }
    
    private func imageCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageCell.reusableIdentifier, for: indexPath) as! ImageCell
        
        if let coverPath = self.epub?.coverURL?.path {
            cell.coverImageView.image = UIImage(contentsOfFile: coverPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section != detailSection) {
            let chapterVC = self.storyboard?.instantiateViewController(withIdentifier: "ChapterVC") as! ChapterViewController
            let (chapter, nextChapter) = getChapters(indexPath)
            chapterVC.content = readChapter(chapter, nextChapter)!
            chapterVC.title = chapter.label

            self.navigationController?.show(chapterVC, sender: self)
        }
    }

    private func getChapters(_ indexPath: IndexPath) -> (ChapterItem, ChapterItem?) {
        let chapter = self.epubPlainChapters[indexPath.item].chapter
        let nextChapter = self.epubPlainChapters.count > indexPath.item ? self.epubPlainChapters[indexPath.item + 1].chapter : nil
        return (chapter, nextChapter)
    }

    private func readChapter(_ indexPath: IndexPath) -> String? {
        let (chapter, nextChapter) = getChapters(indexPath)
        return readChapter(chapter, nextChapter)
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: UIKit.Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == MenuAction.Preview.selector()
    }
    
    func tableView(_ tableView: UITableView, performAction action: UIKit.Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        // This is needed for custom menu even though it's not called.
    }

    private func titleCell(indexPath: IndexPath) -> UITableViewCell {
        return self.commonCell(indexPath: indexPath, title: "Title", value: self.epub?.title)
    }
    
    private func authorCell(indexPath: IndexPath) -> UITableViewCell {
        return self.commonCell(indexPath: indexPath, title: "Author", value: self.epub?.author)
    }
    
    private func publisherCell(indexPath: IndexPath) -> UITableViewCell {
        return self.commonCell(indexPath: indexPath, title: "Publisher", value: self.epub?.publisher)
    }
    
    private func languageCell(indexPath: IndexPath) -> UITableViewCell {
        return self.commonCell(indexPath: indexPath, title: "Language", value: self.epub?.language)
    }
    
    private func identifierCell(indexPath: IndexPath) -> UITableViewCell {
        return self.commonCell(indexPath: indexPath, title: "Identifier", value: self.epub?.identifier)
    }
    
    private func chapterCell(indexPath: IndexPath) -> UITableViewCell {        
        let plainChapter = self.epubPlainChapters[indexPath.item]

        let chapterCell: ChapterCell = ChapterCell(style: .default, reuseIdentifier: "ChapterCell")
        chapterCell.storyboard = self.storyboard
        chapterCell.navigationController = self.navigationController
        
        let (chapter, nextChapter) = getChapters(indexPath)
        chapterCell.content = parseContent(readChapter(chapter, nextChapter)!)
        chapterCell.textLabel?.text = plainChapter.chapter.label
        chapterCell.textLabel?.numberOfLines = 0
        chapterCell.indentationLevel = plainChapter.indentationLevel
        
        return chapterCell
    }
    
    private func commonCell(indexPath: IndexPath, title: String, value: String?) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CommonCell")
        }
        
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = value
        
        return cell!
    }

    func readChapter(_ chapter: ChapterItem, _ nextChapter: ChapterItem?) -> String? {
        var content = chapterContents[chapter.uniqueSrc]
        if content == nil {
            content = readContentFromUrl(chapter.src, chapter.bookmark, nextChapter?.bookmark )
            chapterContents[chapter.uniqueSrc] = content
        }
        return content
    }

    private func readContentFromUrl(_ url: URL, _ currentBookmark: String?, _ nextBookmark: String?) -> String {
        do {
            return readChapterHtml(try String(contentsOf: url, encoding: .utf8), currentBookmark, nextBookmark);
        } catch let error {
            print("Error: \(error)")
        }
        return ""
    }
    
    private func readChapterHtml(_ content: String, _ currentChapterBookmark: String?, _ nextChapterBookmark: String?) -> String {
        var html = ""
        if content.count != 0  {
            do{
                let doc: Document = try SwiftSoup.parse(content)
                let body: Element = doc.body()!
                if currentChapterBookmark != nil {
                    html = "<html>\(doc.head()!)<body>"
                    let children = body.getChildNodes()
                    var found = false
                    for child in children {
                        let id = try child.attr("id")
                        if !found {
                            if(currentChapterBookmark != id) {
                                continue
                            } else {
                                found = true
                            }
                        }
                        if found {
                            if nextChapterBookmark != nil && id == nextChapterBookmark {
                                break
                            } else {
                                html += try child.outerHtml()
                            }
                        }
                    }
                    html += "</body>"
                }
                return html
            } catch Exception.Error(let type, let message){
                print(type)
                print(message)
            } catch {
                print("error")
            }
        }
        return ""
    }

    func parseContent(_ content: String) -> String {
        if content.count != 0  {
            do{
                let body = try SwiftSoup.parse(content).body()!
                return try body.text()
            } catch Exception.Error(let type, let message){
                print(type)
                print(message)
            } catch {
                print("error")
            }
        }
        return ""
    }
}

extension EpubDetailViewController: EpubExtractorDelegate {
    func epubExactorDidExtractEpub(_ epub: Epub) {
        self.epub = epub
        self.tableView?.reloadData()
    }
    
    func epubExtractorDidFail(error: Error?) {
        print("error while extracting the epub: \(String(describing: error))")
    }
}
