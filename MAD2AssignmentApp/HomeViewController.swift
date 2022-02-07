//
//  HomeViewController.swift
//  MAD2AssignmentApp
//
//  Created by Cammy Lim on 17/1/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    var selectedDate = Date()
    var selectedDay:String?
    var selectedMonth:String?
    var selectedYear:String?
    var legitimateCell:Bool?
    var totalDays = [String]()
    let diaryDAL:DiaryDataAccessLayer = DiaryDataAccessLayer()
    var diaryEntries:[Diary]?
    var diaryEntriesFilled:[String]?
    var feelingsFilled:[String]?
    var quotes = Quote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "home-bg.svg")!)
        
        //set day and date labels
        dayLabel.text = DiaryCalendar().dayText(date: selectedDate) + ","
        dateLabel.text = DiaryCalendar().monthText(date: selectedDate) + " " + String(DiaryCalendar().dayOfMonth(date: selectedDate))
        
        //configure the rest of the page
        diaryEntries = diaryDAL.RetrieveAllDiaryEntries()
        setGreetingView()
        setCellsView()
        setMonthView()
        
        //update collectionview
        collectionView.reloadData()
        
        // quote of the day
        let birthdate:Date = diaryDAL.RetrieveUser().dob!
        let birthday = DiaryCalendar().dayText(date: birthdate)
        let birthmonth = DiaryCalendar().monthText(date: birthdate)
        let todaysday = DiaryCalendar().dayText(date: Date())
        let todaysmonth = DiaryCalendar().monthText(date: Date())
        //birthday message algorithm
        if(birthday == todaysday && birthmonth == todaysmonth){
            let text = "Happy Birthday, \(diaryDAL.RetrieveUser().name!)! May today be your happiest day."
            let text2 = "Happy Birthday, \(diaryDAL.RetrieveUser().name!)!"
            let text3 = "Happy Birthday!"
            if (text.count > 70){
                if(text2.count > 70){ self.quoteLabel.text = text3 }
                else { self.quoteLabel.text = text2 }
            } else { self.quoteLabel.text = text }
            self.authorLabel.text = "by The 'Diaryme' Team"
        }else{
            //random quote
            NetworkService.sharedobj.getQuotes { (w) in
                self.quotes = w
                
                if var randomquote = self.quotes.randomElement()
                {
                    while randomquote.text.count > 70 {
                        randomquote = self.quotes.randomElement()!
                    }
                    self.quoteLabel.text = "\(randomquote.text)"
                    if (randomquote.author == nil) {
                        self.authorLabel.text = "by anonymous"
                    } else {
                        self.authorLabel.text = "by \(randomquote.author!)"
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //update the page
        diaryEntries = diaryDAL.RetrieveAllDiaryEntries()
        setGreetingView()
        setCalendarColor()
        collectionView.reloadData()
    }
    
    //when "Enter Mood" button is clicked
    @IBAction func moodEntry(_ sender: Any) {
        self.performSegue(withIdentifier: "moodDiaryDetail", sender: self)
    }
    
    //set the greeting view
    func setGreetingView(){
        var greetTime:String = ""
        var greetName:String = ""
        if (DiaryCalendar().hour(date: selectedDate) < 12){
            greetTime = "Good Morning, "
        }
        else if (DiaryCalendar().hour(date: selectedDate) < 17){
            greetTime = "Good Afternoon, "
        }
        else if (DiaryCalendar().hour(date: selectedDate) < 19){
            greetTime = "Good Evening, "
        }
        else{
            greetTime = "Good Night, "
        }
        greetName = diaryDAL.RetrieveUser().name!
        greetingLabel.text = greetTime + greetName
    }
    
    //set the size of the cells
    func setCellsView(){
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
    }
    
    //set the month and year labels, set the totalDays value for cell numbers allocation
    func setMonthView(){
        totalDays.removeAll()
        let totalDaysInMonth = DiaryCalendar().totalDaysInMonth(date:selectedDate)
        let firstDayOfMonth = DiaryCalendar().firstDayOfMonth(date:selectedDate)
        let startingDays = DiaryCalendar().weekDay(date: firstDayOfMonth)
        
        var count:Int = 1
        
        while(count <=  42){
            if(count <= startingDays || count - startingDays > totalDaysInMonth){
                totalDays.append("")
            }
            else{
                totalDays.append(String(count-startingDays))
            }
            count+=1
        }
        monthLabel.text = DiaryCalendar().monthText(date: selectedDate)
        yearLabel.text = DiaryCalendar().yearText(date: selectedDate)
        
        collectionView.reloadData()
    }
    
    //set the list of feeling-colors on the calendar
    func setCalendarColor(){
        diaryEntriesFilled=[]
        feelingsFilled=[]
        var i:Int=0
        while i < diaryEntries!.count{
            let diaryDate:Date = diaryEntries![i].date!
            if(DiaryCalendar().monthText(date: diaryDate) == DiaryCalendar().monthText(date: selectedDate)
               && DiaryCalendar().yearText(date: diaryDate) == DiaryCalendar().yearText(date: selectedDate)){
                diaryEntriesFilled?.append(String(DiaryCalendar().dayOfMonth(date: diaryDate)))
                feelingsFilled?.append(diaryEntries![i].feeling!)
            }
            i+=1
        }
    }
    
    //Collection View Functions
    //set number of items in the collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDays.count
    }
    
    //set view for each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaCell", for: indexPath) as! DiaryCell
        
        //set cell design
        cell.day.text = totalDays[indexPath.item]
        cell.backgroundColor = UIColor.clear
        if (totalDays[indexPath.item] != ""){
            cell.layer.cornerRadius = 13.0
            cell.day.text = totalDays[indexPath.item]
            var i:Int = 0
            while i < diaryEntriesFilled!.count{
                if (diaryEntriesFilled![i] == totalDays[indexPath.item]){
                    //set the backgroundcolor of the cell
                    cell.backgroundColor = UIColor(hexString: feelingsFilled![i])
                }
                i+=1
            }
        }
        return cell
    }
    
    //if cell/day is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.totalDays[indexPath.row] != ""){
            let checkDay = self.totalDays[indexPath.row]
            let checkMonth = DiaryCalendar().monthText(date: selectedDate)
            let checkYear = DiaryCalendar().yearText(date: selectedDate)
            let checkDate = DiaryCalendar().StringtoDate(string: (checkDay + "/" +  checkMonth + "/" + checkYear))
            print(checkDate)
            if(Date().compare(checkDate) == .orderedDescending){
                self.performSegue(withIdentifier: "diaryDetail", sender: self)
            }
            
        }
    }
    
    //prepare values for the next viewcontroller in the respective segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dayVC = segue.destination as? DayViewController else{
            return
        }
        if (segue.identifier == "diaryDetail"){
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0]
            selectedDay = self.totalDays[indexPath.row]
            dayVC.selectedDay = selectedDay
        }
        else if (segue.identifier == "moodDiaryDetail"){
            selectedDay = String(DiaryCalendar().dayOfMonth(date: selectedDate))
            dayVC.selectedDay = selectedDay
        }
        dayVC.selectedMonth = DiaryCalendar().monthText(date: selectedDate)
        dayVC.selectedYear = DiaryCalendar().yearText(date: selectedDate)
        dayVC.selectedDate = DiaryCalendar().StringtoDate(string: (selectedDay! + "/" +  DiaryCalendar().monthText(date: selectedDate) + "/" + DiaryCalendar().yearText(date: selectedDate)))
    }
    
    //perform functions before performing segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier != "viewProfile") {
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            if (!indexPaths.isEmpty) {
                let indexPath = indexPaths[0]
                if (self.totalDays[indexPath.row] != ""){
                    let checkDay = self.totalDays[indexPath.row]
                    let checkMonth = DiaryCalendar().monthText(date: selectedDate)
                    let checkYear = DiaryCalendar().yearText(date: selectedDate)
                    let checkDate = DiaryCalendar().StringtoDate(string: (checkDay + "/" +  checkMonth + "/" + checkYear))
                    if(Date().compare(checkDate) == .orderedDescending){
                        return true
                        
                    }
                }
            }
            return false
        } else {
            return true
        }
    }
    
    //when previousMonth button is clicked, minus the month
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = DiaryCalendar().minusMonth(date: selectedDate)
        setMonthView()
        setCalendarColor()
    }
    
    //when nextMonth button is clicked, add the month
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = DiaryCalendar().addMonth(date: selectedDate)
        setMonthView()
        setCalendarColor()
    }
    
    override open var shouldAutorotate: Bool{
        return false
    }
}

//customization of UIColors via hex values
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

