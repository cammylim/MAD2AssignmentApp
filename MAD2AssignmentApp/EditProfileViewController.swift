//
//  EditProfileViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 26/1/22.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var dobMsg: UILabel!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "profile-bg.svg")!);
        nameMsg.text = ""
        dobMsg.text = ""
        dobField.delegate = self

        // get user information
        let user:User = diaryDAL.RetrieveUser()
        
        // display user information
        nameField.text = user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dob = dateFormatter.string(from: user.dob!)
        dobField.text = dob
    }
    
    @IBAction func backToProfile(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)

        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        if (nameField.text == "" && dobField.text == "") { // validation
            nameMsg.text = "Please enter your name."
            dobMsg.text = "Please select your date of birth."
        } else if (nameField.text == "" && dobField.text != "") { // validation
            nameMsg.text = "Please enter your name."
            dobMsg.text = ""
        } else if (nameField.text != "" && dobField.text == "") { // validation
            nameMsg.text = ""
            dobMsg.text = "Please select your date of birth."
        } else if (nameField.text != "" && dobField.text != "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"

            let newUser:User = User(name: nameField.text!, dob: dateFormatter.date(from: dobField.text!)!)
            diaryDAL.EditUser(newUser: newUser)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }
    
    // hide keyboard when tap on empty space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
   }
}

extension EditProfileViewController {
    func openDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerHandler(datePicker: )), for: .valueChanged)
        datePicker.maximumDate = Date()
        dobField.inputView = datePicker
        datePicker.setValue(UIColor.white , forKey: "backgroundColor")

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTap))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTap))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setValue(UIColor.lightGray , forKey: "backgroundColor")

        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        dobField.inputAccessoryView = toolbar
    }
    
    @objc func cancelBtnTap() {
        dobField.resignFirstResponder()
    }
    
    @objc func doneBtnTap() {
        if let datePicker = dobField.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            dobField.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
}
