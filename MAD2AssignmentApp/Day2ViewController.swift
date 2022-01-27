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
    var tagsActivities:[Activities]?
    var closeButtonPressed:Bool = false
    var selectedDate:Date?
    var diary:Diary?
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var otherTagsField: UITextField!
    @IBOutlet weak var entryMsg: UILabel!
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
        var i = 0
        if(diaryDAL.BoolActivitiesinDiary(diary: diary!)){
            tagList = []
            tagsActivities = diaryDAL.RetrieveActivitiesinDiary(diary: diary!)
            while i < tagsActivities!.count{
                print(tagsActivities![i].act_name!)
                tagList?.append(tagsActivities![i].act_name!)
                tagsPressed.append(tagsActivities![i].act_name!)
                i+=1
            }
            
            i = 0
            while i < tagList!.count {
                tagView = tagListView.addTag(tagList![i])
                tagView.isSelected = true
                i += 1
            }
        }
        else{
            tagList = ["Shopping", "Exercising", "Gardening"]
            while i < tagList!.count {
                tagView = tagListView.addTag(tagList![i])
                tagView.isSelected = false
                i += 1
            }
        }
    }
    
    //prepare values for the next segue before performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDay3"){
            guard let day3VC = segue.destination as? Day3ViewConroller else{
                return
            }
            day3VC.selectedDate = selectedDate
            day3VC.diary = diary
        }
    }
        
    //perform functions and conditions before segue is performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var boolCheck:Bool?
        if(identifier == "backToHome"){
            if(!(diaryDAL.BoolActivitiesinDiary(diary: diary!))){
                diaryDAL.deleteDiary(diary_date: selectedDate!)
            }
            entryMsg.text = "Entry Completion: 2/4"
            entryMsg.textColor = UIColor(hexString: "1158BF")
            boolCheck = true
        }
        else if(tagsPressed.count > 0){
            var i:Int=0
            var act:Activities?
            if(diaryDAL.BoolActivitiesinDiary(diary: diary!)){
                diaryDAL.DeleteActivitiesinDiary(diary: diary!)
            }
            while i < tagsPressed.count{
                print(tagsPressed[i])
                act = Activities(act_name: tagsPressed[i], act_date: selectedDate!)
                diaryDAL.addActivitiestoDiary(diary: diary!, activity: act!)
                i+=1
            }
            
            entryMsg.text = "Entry Completion: 2/4"
            entryMsg.textColor = UIColor(hexString: "1158BF")
            boolCheck = true
        }
        else{
            entryMsg.text = "What did you do today?"
            entryMsg.textColor = UIColor.red
            boolCheck = false
        }
        return boolCheck!
    }
    
    //when back button is pressed
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //when Add button is pressed
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
    
    //when an activity tag is pressed
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
    
    //when a tag is removed
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        var boolCheck = false
        var position:Int?
        var i = 0
        while i < tagsPressed.count {
            if (tagsPressed[i] == title){
                boolCheck = true
                position = i
            }
            i+=1
        }
        if (boolCheck) {
            tagsPressed.remove(at: position!)
        }
        sender.removeTagView(tagView)
    }
}

