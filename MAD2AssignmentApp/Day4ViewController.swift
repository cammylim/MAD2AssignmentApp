//
//  Day4ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation
import UIKit

class Day4ViewController: UIViewController {
    
    var selectedDate: Date?
    var diary: Diary?
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    let diaryDAL: DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
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
            let reflect = diaryDAL.RetrieveReflectioninDiary(diary: diary!)
            print(reflect.ref_title)
            print(reflect.ref_date)
        }
    }
    
}
