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
    var selectedDate:Date?
    var feelingsList:[Feelings] = []
    var selectedFeeling:String = ""
    var diary:Diary?
    
    var diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    @IBOutlet weak var feelingsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!);
        feelingsList = [
            Feelings(feeling_name: "Ecstatic", feeling_image: "diary-5", feeling_date: selectedDate!),
            Feelings(feeling_name: "Happy", feeling_image: "diary-4", feeling_date: selectedDate!),
            Feelings(feeling_name: "Neutral", feeling_image: "diary-3", feeling_date: selectedDate!),
            Feelings(feeling_name: "Upset", feeling_image: "diary-2", feeling_date: selectedDate!),
            Feelings(feeling_name: "Sad", feeling_image: "diary-1", feeling_date: selectedDate!),
        ]
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
        cell.setup(with: feelingsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeelingsCell
        if (cell.backgroundColor == UIColor.clear){
            if(selectedFeeling==""){
                selectedFeeling = cell.feelingsLabel.text!
                cell.layer.cornerRadius = 8
                cell.backgroundColor = UIColor(red: 0.829, green: 0.897, blue: 1, alpha: 1)
            }
        }else{
            cell.backgroundColor = UIColor.clear
            selectedFeeling = ""
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(!(selectedFeeling=="")){
            diary = Diary(feeling: selectedFeeling, date: selectedDate!)
            var feeling:Feelings?
            var i:Int = 0
            while i < feelingsList.count{
                if(selectedFeeling == feelingsList[i].feeling_name){feeling=feelingsList[i]}
                i+=1
            }
            diaryDAL.addFeelingstoDiary(diary: diary!, feelings: feeling!)
            
            return true
        }
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDay2"){
            guard let day2VC = segue.destination as? Day2ViewController else{
                return
            }
            day2VC.selectedDate = selectedDate
            day2VC.diary = diary
        }
    }
}
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 141, height: 85)
    }
}


    
