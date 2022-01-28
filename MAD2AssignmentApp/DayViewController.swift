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
    var selectedFeelingString:String = ""
    var selectedFeeling:Feelings?
    var selectedFeelingCell:UICollectionViewCell?
    var diary:Diary?
    var diaryExists:Bool?
    
    var diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    
    @IBOutlet weak var feelingsCollectionView: UICollectionView!
    @IBOutlet weak var entryMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "diary-bg.svg")!)
        getDiaryAndFeeling()
        feelingsList = [
            Feelings(feeling_name: "Ecstatic", feeling_rgb: "FFF09D", feeling_image: "diary-5", feeling_date: selectedDate!),
            Feelings(feeling_name: "Happy", feeling_rgb:"FFDE8A", feeling_image: "diary-4", feeling_date: selectedDate!),
            Feelings(feeling_name: "Neutral", feeling_rgb:"FFC691", feeling_image: "diary-3", feeling_date: selectedDate!),
            Feelings(feeling_name: "Upset", feeling_rgb:"FFA070", feeling_image: "diary-2", feeling_date: selectedDate!),
            Feelings(feeling_name: "Sad", feeling_rgb:"FF7563", feeling_image: "diary-1", feeling_date: selectedDate!),
        ]
        feelingsCollectionView.reloadData()
    }
    
    // get diary and Feeling values
    func getDiaryAndFeeling(){
        diaryExists = diaryDAL.DiaryExistinUser(user: diaryDAL.RetrieveUser(), diary_date: selectedDate!)
        if (diaryExists!){
            diary = diaryDAL.RetrieveDiaryinUser(user: diaryDAL.RetrieveUser(), diary_date: selectedDate!)
            selectedFeeling = diaryDAL.RetrieveFeelinginDiary(diary: diary!)
            selectedFeelingString = selectedFeeling!.feeling_name!
        }
    }
    
    // update selectedFeeling value
    func selectFeeling(){
        var i = 0
        while i < feelingsList.count{
            if(selectedFeelingString == feelingsList[i].feeling_name){
                selectedFeeling=feelingsList[i]
            }
            i+=1
        }
    }
    
    // update feeling values in diary
    func updateDiary(){
        diaryDAL.UpdateFeelinginDiary(feeling_name: (selectedFeeling?.feeling_rgb)!, diary_date: selectedDate!)
        diaryDAL.UpdateFeelinginFeeling(feeling: selectedFeeling!, diary_date: selectedDate!)
    }
    
    // when close button is pressed
    @IBAction func closeDiary(_ sender: Any) {
        if(diaryExists!){
            updateDiary()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Collection View functions
    
    // number of items in collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feelingsList.count
    }
    
    //for each cell in collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeelingsCollectionViewCell", for: indexPath) as! FeelingsCell
        cell.setup(with: feelingsList[indexPath.row])
        if (cell.feelingsLabel.text == selectedFeelingString){
            selectedFeelingCell = cell
            cell.layer.cornerRadius = 8
            cell.backgroundColor = UIColor(red: 0.925, green: 0.947, blue: 1, alpha: 1)
        }
        return cell
    }
    
    //when a cell is selected in collectionview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeelingsCell
        if (cell.backgroundColor == UIColor.clear){            
            if (!(selectedFeelingString=="")){
                selectedFeelingCell!.backgroundColor = UIColor.clear
            }
            selectedFeelingString = cell.feelingsLabel.text!
            selectedFeelingCell = cell
            selectFeeling()
            cell.layer.cornerRadius = 8
            cell.backgroundColor = UIColor(red: 0.925, green: 0.947, blue: 1, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.clear
            selectedFeelingString = ""
        }
    }
    
    //perform functions before performing segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(!(selectedFeelingString=="")){
            if(diaryExists!){
                updateDiary()
            }
            else{
                diary = Diary(feeling: (selectedFeeling?.feeling_rgb)!, date: selectedDate!)
                diaryDAL.addDiaryToUser(user: diaryDAL.RetrieveUser(), diary: diary!)
                diaryDAL.addFeelingstoDiary(diary: diary!, feelings: selectedFeeling!)
            }
            
            entryMsg.text = "Entry Completion: 1/4"
            entryMsg.textColor = UIColor(hexString: "1158BF")
            return true
        }
        entryMsg.text = "How did you feel today?"
        entryMsg.textColor = UIColor.red
        return false
    }
    
    //prepare values for the next viewcontroller when segue is performed
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

//customized collectionview layout
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 141, height: 85)
    }
}


    
