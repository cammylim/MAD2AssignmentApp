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
    var reflection:Reflection?
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
        prepareReflection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareReflection()
    }
    //prepare reflection inputs
    func prepareReflection(){
        if(diaryDAL.BoolReflectioninDiary(diary: diary!)){
            reflection = diaryDAL.RetrieveReflectioninDiary(diary: diary!)
            if !(reflection?.ref_title == "Add title here"){
                titleField.text = reflection?.ref_title
            }
            if !(reflection?.ref_body == "Add body here"){
                bodyField.text = reflection?.ref_body
                bodyField.textColor = UIColor.black
            }
        }
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
    
    //perform functions before performing segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "day4ToHome"){
            reflection = Reflection(ref_title: titleField.text!, ref_body: bodyField.text, ref_date: selectedDate!)
            if(diaryDAL.BoolReflectioninDiary(diary: diary!)){
                diaryDAL.UpdateReflectioninReflection(ref: reflection!, diary_date: selectedDate!)
            }
            else{
                diaryDAL.DeleteSpecialinDiary(diary: diary!)
                diaryDAL.DeleteActivitiesinDiary(diary: diary!)
                diaryDAL.deleteDiary(diary_date: selectedDate!)
            }
        }
        return true
    }
    // save to core data
    @IBAction func saveReflectionBtn(_ sender: Any) {
        if (titleField.text != "" || bodyField.text != "") {
            reflection = Reflection(ref_title: titleField.text!, ref_body: bodyField.text, ref_date: selectedDate!)
            if(diaryDAL.BoolReflectioninDiary(diary: diary!)){
                diaryDAL.UpdateReflectioninReflection(ref: reflection!, diary_date: selectedDate!)
            }
            else{
                diaryDAL.addReflectiontoDiary(diary: diary!, ref: reflection!)
            }
        }
    }
    
}
