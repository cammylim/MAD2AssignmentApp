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
    var selectedDay:String?
    var selectedMonth:String?
    var selectedYear:String?
    var diary:Diary?

    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var otherTagsField: UITextField!
    @IBOutlet weak var entryMsg: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!)
        entryDate.text = "\(selectedDay!) \(selectedMonth!) \(selectedYear!)"
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
            tagList = diaryDAL.RetrieveActivitiesFromUser()
            while i < tagList!.count {
                tagView = tagListView.addTag(tagList![i] as String)
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
            day3VC.selectedDay = selectedDay
            day3VC.selectedMonth = selectedMonth
            day3VC.selectedYear = selectedYear
            day3VC.selectedDate = selectedDate
            day3VC.diary = diary
        }
    }
        
    //perform functions and conditions before segue is performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var boolCheck:Bool?
        if(identifier == "backToHome"){
            if(!(diaryDAL.BoolActivitiesinDiary(diary: diary!))){
                closeEntryAlert()
                diaryDAL.deleteDiary(diary_date: selectedDate!)
            }
            entryMsg.text = "Entry Completion: 2/4"
            entryMsg.textColor = UIColor(hexString: "1158BF")
            boolCheck = true
        }
        else if(tagsPressed.count > 0){
            saveAct()
            
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
    
    // ask user if they want to close as entry will be deleted
    func closeEntryAlert() {
        let alertView = UIAlertController(title: "Close Entry",
                                          message: "If you close this entry, all your previous input and changes will be deleted. Do you want to close anyway?",
                                          preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Cancel",
                                          style: UIAlertAction.Style.cancel,
                                          handler: { (_) in print("cancel close entry")
        }))
        alertView.addAction(UIAlertAction(title: "Close",
                                          style: UIAlertAction.Style.default,
                                          handler: {_ in self.performSegue(withIdentifier: "backToHome", sender: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    //when back button is pressed
    @IBAction func backButton(_ sender: Any) {
        saveAct()
        
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)

        self.dismiss(animated: false, completion: nil)
    }
    
    //when Add button is pressed
    @IBAction func addOthersButton(_ sender: Any) {
        if (otherTagsField.text != "" && !((tagList?.contains(otherTagsField.text!))!)){
            tagView = tagListView.addTag(otherTagsField.text!)
            tagList?.append(otherTagsField.text!)
            diaryDAL.addActivitiestoUser(activities: tagList!)
            tagView.isSelected = false
            otherTagsField.text = ""
            entryMsg.text = "Entry Completion: 2/4"
            entryMsg.textColor = UIColor(hexString: "1158BF")
        }
        else{
            entryMsg.text = "Unable to add tag."
            entryMsg.textColor = UIColor.red
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
        i = 0
        while i < tagList!.count{
            if(tagList![i] == title){
                tagList?.remove(at: i)
                diaryDAL.removeActivityinUser(act: title)
            }
            i+=1
        }
        
        sender.removeTagView(tagView)
    }
    
    // save activities to core data
    func saveAct() {
        if(tagsPressed.count > 0){
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
            diaryDAL.addActivitiestoUser(activities: tagsPressed)
        }
    }
}

