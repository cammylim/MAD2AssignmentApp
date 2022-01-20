//
//  DayViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 20/1/22.
//

import Foundation
import UIKit

class DayViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var selectedDay:String?
    var selectedMonth:String?
    var selectedYear:String?
    
    let feelingsList:[Feelings] = [
        Feelings(feelings_name: "Ecstatic", feelings_image: UIImage(named:"diary_5.svg")!),
        Feelings(feelings_name: "Happy", feelings_image: UIImage(named:"diary_4.svg")!),
        Feelings(feelings_name: "Neutral", feelings_image: UIImage(named:"diary_3.svg")!),
        Feelings(feelings_name: "Upset", feelings_image: UIImage(named:"diary_2.svg")!),
        Feelings(feelings_name: "Sad", feelings_image: UIImage(named:"diary_1.svg")!)
    ]
    
    @IBOutlet weak var feelingsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        feelingsCollectionView.reloadData()
        
    }
    
    @IBAction func closeDiary(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feelingsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeelingsCollectionViewCell", for: indexPath) as! FeelingsCell
        print(feelingsList[indexPath.row].feelings_name!)
        cell.setup(with: feelingsList[indexPath.row])
        return cell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 141, height: 85)
    }
}
