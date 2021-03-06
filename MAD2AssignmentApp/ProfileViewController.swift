//
//  ProfileViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "profile-bg.svg")!);
        
        displayDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayDetails()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)

        self.dismiss(animated: false, completion: nil)
    }
    
    func displayDetails() {
        // get user information
        let user:User = diaryDAL.RetrieveUser()
        
        // display user information
        nameField.text = user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dob = dateFormatter.string(from: user.dob!)
        dobField.text = dob
    }
    
}
