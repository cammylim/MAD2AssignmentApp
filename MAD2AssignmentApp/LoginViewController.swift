//
//  LoginViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 13/1/22.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var dobMsg: UILabel!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login-bg.svg")!);
        nameMsg.text = ""
        dobMsg.text = ""
        dobField.delegate = self
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }

    @IBAction func loginBtn(_ sender: Any) {
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
            nameMsg.text = ""
            dobMsg.text = ""
            // format date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            // add user to coredata
            let defaultAct:[String] = ["Shopping", "Exercising"]
            let user = User(name: nameField.text!, dob: dateFormatter.date(from: dobField.text!)!, act: defaultAct)
            diaryDAL.AddUser(user: user)
            UserDefaults.standard.hasOnboarded = true
            
            // go to home page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

extension LoginViewController {
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
        toolbar.setValue(UIColor.lightGray, forKey: "backgroundColor")
        
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
