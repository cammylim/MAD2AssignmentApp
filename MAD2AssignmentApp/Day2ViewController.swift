//
//  Day2ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 22/1/22.
//

import Foundation
import UIKit

class Day2ViewController:UIViewController, TagListViewDelegate, UITextFieldDelegate {
    
    var tagList:[Activities]!
    var newActivity:Activities?
    var tag:String?
    var tagView:TagView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var otherTagsField: UITextField!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "BalsamiqSans-Regular", size: 16)!
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
        tagList = diaryDAL.RetrieveAllActivities()
        var i = 0
        while i < tagList!.count {
            tagView = tagListView.addTag(tagList[i].act_name!)
            self.tagListView.tagPressed(tagView)
            tagView.isSelected = false
            i += 1
        }
    }
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        
    }
    @IBAction func addOthersButton(_ sender: Any) {
        if (otherTagsField.text != nil){
            newActivity = Activities(act_name: otherTagsField.text!)
            //diaryDAL.addActivitiestoUser(user: diaryDAL.RetrieveUser(), activity: newActivity!)
            tagView = tagListView.addTag((newActivity?.act_name!)!)
            self.tagListView.tagPressed(tagView)
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
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        //diaryDAL.removeActivitiesfromUser(user: diaryDAL.RetrieveUser(), activity: <#T##Activities#>)
        sender.removeTagView(tagView)
    }
}

