//
//  DayViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 20/1/22.
//

import Foundation
import UIKit

class DayViewController:UIViewController{
    
    var selectedDay:String?
    var selectedMonth:String?
    var selectedYear:String?
    @IBOutlet weak var day: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        day.text = selectedMonth! + " " + selectedDay! + " " + selectedYear!
    }
}
