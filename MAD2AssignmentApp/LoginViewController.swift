//
//  LoginViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 13/1/22.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    let userDAL:UserDataAccessLayer = UserDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login-bg.png")!);
        dobField.delegate = self
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if (nameField.text != "" && dobField.text != "") {
            // format date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            // add user to coredata
            let user = User(name: nameField.text!, dob: dateFormatter.date(from: dobField.text!)!)
            userDAL.AddUser(user: user)
            UserDefaults.standard.hasOnboarded = true
            
            // go to home page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
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
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTap))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTap))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
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
