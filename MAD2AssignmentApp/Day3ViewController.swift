//
//  Day3ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 24/1/22.
//

import Foundation
import UIKit
import PhotosUI

class Day3ViewConroller: UIViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        showPicker()
    }
    
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
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
}
