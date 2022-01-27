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
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    let diaryDAL: DiaryDataAccessLayer = DiaryDataAccessLayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        
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
    
    // save to core data
    @IBAction func saveSpecialBtn(_ sender: Any) {
        if (imageChanged == true || captionField.text != "" || locationField.text != "") {
            let special:Special = Special(special_caption: captionField.text!, special_location: locationField.text!, special_date: selectedDate!, special_image: imageUpload.image!)
            diaryDAL.addSpecialtoDiary(diary: diary!, special: special)
            let spec = diaryDAL.RetrieveSpecialinDiary(diary: diary!)
            print(spec.special_caption)
            print(spec.special_date)
        }
    }
    
}
