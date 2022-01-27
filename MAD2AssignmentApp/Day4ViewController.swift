//
//  Day4ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation
import UIKit

class Day4ViewController: UIViewController, UITextViewDelegate {
    
    var selectedDate: Date?
    var diary: Diary?
    @IBOutlet weak var titleField: UITextField!
//    @IBOutlet weak var bodyField: UITextField!
    @IBOutlet weak var bodyField: UITextView!
    let diaryDAL: DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        bodyField.delegate = self
        bodyField.text = "Add body here"
        bodyField.textColor = UIColor.systemGray3
        bodyField.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        bodyField.layer.cornerRadius = 6
        bodyField.layer.masksToBounds = true
        bodyField.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        bodyField.layer.borderWidth = CGFloat(1)
    }
    
    // modify body text field (text view)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyField.textColor == UIColor.systemGray3 {
            bodyField.text = nil
            bodyField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyField.text.isEmpty {
            bodyField.text = "Add body here"
            bodyField.textColor = UIColor.systemGray3
        }
    }
    
    // hide keyboard when tap on empty space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
   }
    
    // to previous page
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // save to core data
    @IBAction func saveReflectionBtn(_ sender: Any) {
        if (titleField.text != "" || bodyField.text != "") {
            let reflection: Reflection = Reflection(ref_title: titleField.text!, ref_body: bodyField.text, ref_date: selectedDate!)
            diaryDAL.addReflectiontoDiary(diary: diary!, ref: reflection)
        }
    }
    
}
