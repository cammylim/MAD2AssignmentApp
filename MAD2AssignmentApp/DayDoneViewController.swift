//
//  DayDoneViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation
import UIKit

class DayDoneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-done-bg.svg")!);
    }
    
    // to prev page
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
