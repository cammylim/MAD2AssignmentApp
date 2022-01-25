//
//  Day4ViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation
import UIKit

class Day4ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var bodyLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
    }
    
}
