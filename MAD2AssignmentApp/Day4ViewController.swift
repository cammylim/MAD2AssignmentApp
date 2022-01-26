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
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var bodyLabel: UITextField!
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
    
    // to home or next
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "day4ToHome") {
            guard segue.destination is HomeViewController else{
                return
            }
//            diaryDAL.deleteDiary(diary_date: selectedDate!)
        }
    }
}
