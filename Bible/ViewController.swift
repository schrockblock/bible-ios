//
//  ViewController.swift
//  Bible
//
//  Created by Elliot Schrock on 12/26/16.
//  Copyright © 2016 Thryv. All rights reserved.
//

import UIKit
import BibleManager

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dummyTextField: UITextField!
    lazy var datasource: VerseDatasource = VerseDatasource()
    lazy var pickerView = UIPickerView()
    var pickerDatasource: ChapterPickerViewDatasource!
    var tapRecognizer: UITapGestureRecognizer?
    var book: Book?
    var chapter: Int64 = Int64(UserDefaults.standard.integer(forKey: "chapter"))
    var verses: Array<Verse>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        book = Book.loadSavedBook()
        
        if chapter == 0 {
            chapter = 1;
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        self.navigationController?.navigationBar.addGestureRecognizer(tapRecognizer)
        
        self.datasource.tableView = tableView

        displayChapter()
        
        pickerDatasource = ChapterPickerViewDatasource()
        pickerDatasource.pickerView = pickerView
        pickerView.dataSource = pickerDatasource
        pickerView.delegate = pickerDatasource
        dummyTextField.inputView = pickerView
    }
    
    func displayChapter(){
        self.title = "\(book!.name) \(chapter) ▿"
        
        BibleManager.bibleManager.verses(of: book!, chapter: chapter, completion: { (bookVerses) in
            self.verses = bookVerses
            self.datasource.processVerses(verses: bookVerses)
            self.datasource.refreshTable()
        })
    }
    
    func titleTapped() {
        dummyTextField.becomeFirstResponder()
        
        pickerDatasource.book = book
        pickerDatasource.chapter = Int(chapter)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(done))
        tableView.addGestureRecognizer(tapRecognizer!)
    }
    
    func done() {
        if let recognizer = tapRecognizer {
            tableView.removeGestureRecognizer(recognizer)
        }
        
        dummyTextField.resignFirstResponder()
        
        book = pickerDatasource.book
        book?.save()
        
        chapter = Int64(pickerDatasource.chapter!)
        UserDefaults.standard.set(chapter, forKey: "chapter")
        
        displayChapter()
    }
}

extension Book {
    func save() {
        UserDefaults.standard.set(self.objectId, forKey: "bookId")
        UserDefaults.standard.set(self.name, forKey: "bookName")
        UserDefaults.standard.set(self.abbreviation, forKey: "bookAbbreviation")
        UserDefaults.standard.synchronize()
    }
    
    static func loadSavedBook() -> Book {
        let defaults = UserDefaults.standard
        var storedInt = defaults.integer(forKey: "bookId")
        if storedInt == 0 {
            storedInt = 550
        }
        return Book(objectId: Int64(storedInt), name: defaults.string(forKey: "bookName") ?? "Galatians", abbreviation: defaults.string(forKey: "bookAbbreviation") ?? "Gal")
    }
}

