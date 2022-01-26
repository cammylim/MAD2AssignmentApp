//
//  Day2ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 22/1/22.
//

import Foundation
import UIKit

class Day2ViewController:UIViewController, TagListViewDelegate, UITextFieldDelegate {
    
    var tag:String?
    var tagView:TagView!
    var tagList:[String]?
    var tagsPressed:[String]=[]
    var newActivity:Activities?
    var closeButtonPressed:Bool = false
    var selectedDate:Date?
    var diary:Diary?
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var otherTagsField: UITextField!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "BalsamiqSans-Regular", size: 16)!
        tagsPressed=[]
        setTags()
        
        // keyboard - shift view up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // keyboard - shift view up
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // keyboard - shift view up
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if (notification.name == UIResponder.keyboardWillShowNotification) ||
            (notification.name == UIResponder.keyboardWillChangeFrameNotification) {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    // hide keyboard when tap on empty space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //set the activity tags into view
    func setTags(){
        tagList = ["Shopping", "Exercising", "Gardening"]
        var i = 0
        while i < tagList!.count {
            tagView = tagListView.addTag(tagList![i])
            tagView.isSelected = false
            i += 1
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backToHome"){
            guard segue.destination is HomeViewController else{
                return
            }
            diaryDAL.deleteDiary(diary_date: selectedDate!)
        } else if (segue.identifier == "goToDay3"){
            guard let day3VC = segue.destination as? Day3ViewConroller else{
                return
            }
            day3VC.selectedDate = selectedDate
            day3VC.diary = diary
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var boolCheck:Bool = false
        if(tagsPressed.count > 0){
            var i:Int=0
            var act:Activities?
            while i < tagsPressed.count{
                print(tagsPressed[i])
                act = Activities(act_name: tagsPressed[i], act_date: selectedDate!)
                diaryDAL.addActivitiestoDiary(diary: diary!, activity: act!)
                i+=1
            }
            boolCheck = true
        }
        else if(identifier == "backToHome"){
            boolCheck = true
        }
        return boolCheck
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addOthersButton(_ sender: Any) {
        if (otherTagsField.text != ""){
            tagView = tagListView.addTag(otherTagsField.text!)
            tagView.isSelected = false
            otherTagsField.text = ""
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if(tagView.isSelected){
            tagsPressed.append(title)
        }
        else{
            var boolCheck = false
            var position:Int?
            var i = 0
            while i < tagsPressed.count{
                if (tagsPressed[i] == title){
                    boolCheck = true
                    position = i
                }
                i+=1
            }
            if(boolCheck){
                tagsPressed.remove(at: position!)
            }
        }
        print(tagsPressed)
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

