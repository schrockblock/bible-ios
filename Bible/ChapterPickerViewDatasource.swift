//
//  ChapterPickerViewDatasource.swift
//  Bible
//
//  Created by Elliot Schrock on 2/17/17.
//  Copyright © 2017 Thryv. All rights reserved.
//

import UIKit
import BibleManager

class ChapterPickerViewDatasource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    fileprivate var _pickerView: UIPickerView!
    var pickerView: UIPickerView! {
        get {
            return _pickerView
        }
        set (newPicker) {
            _pickerView = newPicker
        }
    }
    var books: Array<Book>!
    var chapterCounts: Dictionary<String, Int64> = Dictionary<String, Int64>()
    fileprivate var _chapter: Int?
    fileprivate var _book: Book?
    var chapter: Int? {
        get {
            return _chapter
        }
        
        set (newChapter) {
            _chapter = newChapter
            if let unwrappedPickerView = pickerView {
                unwrappedPickerView.selectRow(_chapter! - 1, inComponent: 1, animated: true)
            }
        }
    }
    var book: Book! {
        get {
            return _book
        }
        
        set (newBook) {
            _book = newBook
            if let unwrappedPickerView = pickerView {
                unwrappedPickerView.selectRow(books.index(where: { $0.abbreviation == _book?.abbreviation })!, inComponent: 0, animated: true)
            }
        }
    }
    
    override init() {
        super.init()
        BibleManager.bibleManager.books { (bibleBooks) in
            books = bibleBooks
            _book = bibleBooks[0]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return books.count
        case 1:
            BibleManager.bibleManager.numberOfChapters(of: book, completion: { (count) in
                chapterCounts[book.abbreviation] = count
            })
            return Int(chapterCounts[book.abbreviation]!)
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return books[row].name
        case 1:
            return "\(row + 1)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            _book = books[row]
            pickerView.reloadComponent(1)
        } else {
            _chapter = row + 1
        }
    }
}
