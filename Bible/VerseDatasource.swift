//
//  VerseDatasource.swift
//  Bible
//
//  Created by Elliot Schrock on 2/17/17.
//  Copyright © 2017 Thryv. All rights reserved.
//

import UIKit
import BibleManager

class VerseDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView! {
        get {
            return _tableView
        }
        
        set(verseTableView) {
            _tableView = verseTableView
            _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    var _tableView: UITableView!
    var book: Book!
    var chapter: Int64!
    var verseAttributedStrings: Array<NSAttributedString> = Array<NSAttributedString>()
    weak var viewController: UIViewController?
    
    func loadVerses(of book: Book, chapter: Int64){
        self.book = book
        self.chapter = chapter
        
        BibleManager.bibleManager.verses(of: book, chapter: chapter, completion: { (bookVerses) in
            self.processVerses(verses: bookVerses)
            self.refreshTable()
        })
    }
    
    func refreshTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }
    
    func processVerses(verses: Array<Verse>?) {
        verseAttributedStrings = Array<NSAttributedString>()
        do {
            let regex = try NSRegularExpression(pattern: "\\[[0-9]+\\]", options: NSRegularExpression.Options.caseInsensitive)
            if let verseArray = verses {
                for verse in verseArray {
                    verseAttributedStrings.append(self.processVerse(verse: verse, regex: regex)!)
                }
            }
        } catch let e as NSError {
            print("error: \(e.localizedDescription) ")
        }
        
    }
    
    func processVerse(verse: Verse, regex: NSRegularExpression) -> NSAttributedString? {
        let mutableVerseText = NSMutableString(string: verse.text)
        regex.replaceMatches(in: mutableVerseText, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: verse.text.characters.count), withTemplate: "")
        let font = UIFont(name: "Lora", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        let verseText = "<b>\(String(verse.number))</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"font-family: \(font.familyName); font-size: \(font.pointSize)\">\(mutableVerseText.copy() as! String)</span>"
        
        if let htmlData = verseText.data(using: String.Encoding.unicode) {
            do{
                let attributedText = try NSAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                return attributedText
            } catch let e as NSError {
                print("error: \(e.localizedDescription) ")
            }
        }
        return nil
    }
    
    // MARK - table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verseAttributedStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = verseAttributedStrings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let verse = verseAttributedStrings[indexPath.row].string
        let verseShareText = "\(book.abbreviation) \(chapter):\(verse)"
        let activityViewController = UIActivityViewController(activityItems: [verseShareText as NSString], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
