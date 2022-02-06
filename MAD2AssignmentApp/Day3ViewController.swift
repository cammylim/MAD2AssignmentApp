//
//  Day3ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 24/1/22.
//

import Foundation
import UIKit
import PhotosUI

class Day3ViewConroller: UIViewController, PHPickerViewControllerDelegate, UITextFieldDelegate {
    
    var selectedDate: Date?
    var diary: Diary?
    var imageChanged = false
    var special:Special?
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    let diaryDAL: DiaryDataAccessLayer = DiaryDataAccessLayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        if(diaryDAL.BoolSpecialinDiary(diary: diary!)){
            special = diaryDAL.RetrieveSpecialinDiary(diary: diary!)
            if !(special?.special_caption == nil){
                captionField.text = special?.special_caption
            }
            if !(special?.special_location == nil){
                locationField.text = special?.special_location
            }
            if !(special?.special_image == nil){
                imageUpload.image = special?.special_image
            }
        }
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

    // upload image
    @IBAction func uploadImageBtn(_ sender: Any) {
        showPicker()
    }
    
    // configure gallery
    func showPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
                    
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.imageUpload.image = image
                        self.imageChanged = true
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    // to previous page
    @IBAction func backBtn(_ sender: Any) {
        if(diaryDAL.BoolSpecialinDiary(diary: diary!)){
            diaryDAL.UpdateSpecialinSpecial(special: special!, diary_date: selectedDate!)
        } else {
            saveSpec()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // to home or next
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDay4") {
            guard let day4VC = segue.destination as? Day4ViewController else{
                return
            }
            day4VC.selectedDate = selectedDate
            day4VC.diary = diary
        }
    }
    
    // perform required Special functions before performing segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "day3ToHome"){
            if(diaryDAL.BoolSpecialinDiary(diary: diary!)){
                diaryDAL.UpdateSpecialinSpecial(special: special!, diary_date: selectedDate!)
            }
            else{
                closeEntryAlert()
                diaryDAL.DeleteActivitiesinDiary(diary: diary!)
                diaryDAL.deleteDiary(diary_date: selectedDate!)
            }
        }
        return true
    }
    
    // ask user if they want to close as entry will be deleted
    func closeEntryAlert() {
        let alertView = UIAlertController(title: "Close Entry",
                                          message: "If you close this entry, all your previous input will be deleted. Do you want to close anyway?",
                                          preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Cancel",
                                          style: UIAlertAction.Style.cancel,
                                          handler: { (_) in print("cancel close entry")
        }))
        alertView.addAction(UIAlertAction(title: "Close",
                                          style: UIAlertAction.Style.default,
                                          handler: {_ in self.performSegue(withIdentifier: "day3ToHome", sender: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    // save to core data
    @IBAction func saveSpecialBtn(_ sender: Any) {
        saveSpec()
    }
    
    func saveSpec() {
        if (imageChanged == true || captionField.text != "" || locationField.text != "") {
            special = Special(special_caption: captionField.text!, special_location: locationField.text!, special_date: selectedDate!, special_image: imageUpload.image!)
            if(diaryDAL.BoolSpecialinDiary(diary: diary!)){
                diaryDAL.UpdateSpecialinSpecial(special: special!, diary_date: selectedDate!)
            }
            else{
                diaryDAL.addSpecialtoDiary(diary: diary!, special: special!)
            }
        }
    }
    
}
