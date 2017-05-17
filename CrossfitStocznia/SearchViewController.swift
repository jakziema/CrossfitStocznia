//
//  SearchViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub Ziemann on 16.05.2017.
//  Copyright © 2017 Jakub. All rights reserved.
//

import UIKit
import HTMLReader
import SwiftSoup
import ChameleonFramework


class SearchViewController: UIViewController {
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        performSearch(segment: sender.selectedSegmentIndex)
        
        
    }
    
    
    var trainings = [Training]()
    var sections = [Section]()
    var bookings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)
        
        
        tableView.rowHeight = 80
        
        let cellNib = UINib(nibName: TableViewCellIdentifiers.trainingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.trainingCell)
        
        /**
         DispatchQueue.global(qos: .userInitiated).async {
         
         
         DispatchQueue.main.async {
         self.bookings = self.getTrainingsIDs(hrefs: hrefs)
         print("Zaladowano" + self.bookings[0])
         
         }
         }
         */
        let hrefs = self.parseHTML(html: self.getMyReservations(fromHTML: EndpointsConstants.MyReservationsEndpoint.baseURL))
        self.bookings = self.getTrainingsIDs(hrefs: hrefs)
        
        
        
        
        let data = parseJSON(performRequest(getPresentCalendarURL(segment: 0))!)
        sections = parseArraysOfDictionaries(data!)
        
        
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeAppearanceOfTheTopBar()
        
        presentedViewController?.modalPresentationCapturesStatusBarAppearance = true
    }
    
    func performSearch(segment: Int) {
        
        let data = parseJSON(performRequest(getPresentCalendarURL(segment: segment))!)
        sections = parseArraysOfDictionaries(data!)
        tableView.reloadData()
        
    }
    
    func customizeAppearanceOfTheTopBar() {
        
        let barTintColor = UIColor.flatRed
        //let barTintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarView?.backgroundColor = barTintColor
        UISegmentedControl.appearance().tintColor = .white
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //getting classes for two upcoming weeks
    func getPresentCalendarURL(segment: Int)-> String {
        
        
        var calendarURL = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let weekLater = today.addingTimeInterval(7 * 24 * 60 * 60)
        let twoWeeksLater = today.addingTimeInterval(14 * 24 * 60 * 60)
        let weekEarlier = today.addingTimeInterval(-7 * 24 * 60 * 60)
        
        if (segment == 0) {
         calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=\(dateFormatter.string(from: weekEarlier))&date_next=\(dateFormatter.string(from: twoWeeksLater))&date_start=\(dateFormatter.string(from: today))&date_end=\(dateFormatter.string(from: weekLater))"
            
        } else if(segment == 1) {
           calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=666&worktime=events&interval=30&date_prev=\(dateFormatter.string(from: weekEarlier))&date_next=\(dateFormatter.string(from: twoWeeksLater))&date_start=\(dateFormatter.string(from: today))&date_end=\(dateFormatter.string(from: weekLater))"
        } else if(segment == 2) {
            calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=\(dateFormatter.string(from: weekEarlier))&date_next=\(dateFormatter.string(from: twoWeeksLater))&date_start=\(dateFormatter.string(from: today))&date_end=\(dateFormatter.string(from: weekLater))"
        }
        
        
        
        
        print("PRESENT CALENDAR URL:" + calendarURL)
        
        
        
        return calendarURL
    }
    
    
    
    
    func performRequest(_ stringURL: String) -> String? {
        let url = URL(string: stringURL)!
        do {
            
            return try String(contentsOf: url, encoding: String.Encoding.utf8)
        } catch {
            print("Download error: \(error)")
            return nil
        }
    }
    
    func parseJSON(_ jsonString: String) -> [[String:AnyObject]]? {
        guard let data = jsonString.data(using: String.Encoding.utf8)
            else {
                return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    
    
    func parseArraysOfDictionaries(_ array: [[String:AnyObject]])  -> [Section] {
        
        //    var trainings = [Training]()
        
        var sections = [Section]()
        var zmienna = true
        
        var cancelledOrdersArray = [Order]()
        var bookedOrdersArray = [Order]()
        
        for (index,dictionary) in array.enumerated() {
            
            
            
            let training = Training()
            let title  = dictionary["title"] as! String
            let hour = dictionary["hour"] as! String
            let date = dictionary["date"] as! String
            let dateID  = dictionary["date_id"] as! String
            if let orders = dictionary["orders"] as? [[String: Any]] {
                for order2 in orders {
                    
                    if let id = order2["id"] as? String, let user_id = order2["user_id"] as? String {
                        
                        let order = Order()
                        order.id = id
                        order.user_id = user_id
                        
                        for booking in bookings {
                            if booking == order.id {
                                
                            print("\(booking) == \(order.id)")
                             bookedOrdersArray.append(order)
                                print(order.id)
                            }
                        }
                        
                        
                        
                        
                    }
                }
            }
            
            
            
            
            //let orders_2 = dictionary["orders_2"] as! [[String: Any]]
           
            
            
            
            training.dateID = dateID
            training.placesLeft = dictionary["places"] as! Int
            training.bgColor = dictionary["bg"] as! String
            training.hour = String(hour.characters.prefix(5))
            training.titleWithName = title
            //training.title = deleteName(ofTheCoach: title)
            training.title = prepareTitle(text: title)
            training.coachName = getName(OfTheCoach: title)
            training.date = date
            
            //training.id = dictionary["id"] as! String
            training.dateAsDateType = fromStringToDate(dateString: dateID)
            
            
            
            
            
            
            zmienna  = true
            
            if (index == 0) {
                let section = Section(sectionTitle: date, sectionDateAsType: training.dateAsDateType)
                sections.sort(by: { $0.sectionDateAsType < $1.sectionDateAsType })
                sections.append(section)
                
                section.sectionTrainings.append(training)
                section.sectionTrainings.sort(by: { $0.hour < $1.hour})
                
            } else {
                
                for section in sections {
                    if (section.sectionTitle == date) {
                        zmienna =  false
                        sections.sort(by: { $0.sectionDateAsType < $1.sectionDateAsType })
                        section.sectionTrainings.append(training)
                        section.sectionTrainings.sort(by: { $0.hour < $1.hour})
                        
                        break;
                    }
                    
                }
                
                if(zmienna){
                    
                    sections.sort(by: { $0.sectionDateAsType < $1.sectionDateAsType })
                    sections.append(Section(sectionTitle: date, sectionDateAsType: training.dateAsDateType))
                    
                }
            }
        }
        
        
        
        
        
        
        return sections
        
    }
    
    struct TableViewCellIdentifiers {
        static let trainingCell = "TrainingCell"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let tappedCell = sections[indexPath.section].sectionTrainings[indexPath.row]
            detailViewController.training = tappedCell
            
        }
    }
    
    func getName(OfTheCoach text: String) -> String {
        var name = ""
        if let match = text.range(of: "(?<=\\()[^()]{1,10}(?=\\))", options: .regularExpression) {
            name =  text.substring(with: match)
            
        }
        
        return name
    }
    
    
    func deleteName(ofTheCoach text: String) -> String {
        var title = ""
        if let range = text.range(of: "(") {
            title =  text.substring(to: range.lowerBound)
        }
        
        return title
    }
    
    func prepareTitle(text: String) -> String {
        var title = ""
        
        if text.contains("Runmageddon") {
            title = "Runmageddon"
            
        } else if text.contains("Gymnastics C1+2") || text.contains("Gymnastics Class 1+2") {
            title = "Gymnastics C1+2"
        }  else if text.contains("Gymnastics C2"){
            title = "Gymnastics C2"
        } else if text.contains("Class 1 & 2") || text.contains("Class 1+2"){
            title = "Class 1+2"
        } else if text.contains("OLY Class 1") {
            title = "OLY Class 1"
        } else if text.contains("Class 1") {
            title = "Class 1"
        } else if text.contains("Class 2") {
            title =  "Class 2"
        } else if text.contains("Class 3") {
            title = "Class 3"
        }  else if text.contains("OPEN GYM") {
            title = "OPEN GYM"
        } else if text.contains("OLY Class2") {
            title = "OLY Class2"
        }   else if text.contains("WOD C1+2") {
            title = "WOD C1+2"
        } else if text.contains("WOD C1") {
            title = "WOD C1"
        } else if text.contains("Joga") {
            title = "Joga"
        } else if text.contains("Team") {
            title = "TEAM WOD"
        } else if text.contains("Aktywuj") {
            title = "Aktywuj się C1+2"
        } else if text.contains("Mobility") {
            title = "Mobility"
        } else {
            title = "Trening"
        }
        
        return title
    }
    
    
    
    
    func getNameOfTheWeekFrom(dateAsString date: String) -> String? {
        let weekdays = [
            "Niedziela",
            "Poniedziałek",
            "Wtorek",
            "Środa",
            "Czwartek",
            "Piątek",
            "Sobota"
        ]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: date) {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
            return weekdays[weekDay - 1]
        } else {
            return nil
        }
        
    }
    
    /**
     Converting date as String in format: yyyy_MM_dd_HH_mm to Date type
     
     - parameter dateString:  Date as String type
     - returns: DateString as Date type
     */
    
    func fromStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm"
        
        return dateFormatter.date(from: dateString)!
        
    }
    
    
    //MARK: WORKING WITH HREFS
    
    func getTrainingsIDs(hrefs: Set<String>)-> [String] {
        var ids = [String]()
        
        for href in hrefs {
            let id = href.components(separatedBy: "show/")[1]
            
            ids.append(id)
        }
        
        return ids
    }
    
    
    
    func parseHTML(html: String)-> Set<String> {
        
        let duzaSalaString = "http://crossfitstocznia.reservante.pl/calendars/665"
        let malaSalaString = "http://crossfitstocznia.reservante.pl/calendars/666"
        
        var hrefs = Set<String>()
        
        let htmlDocument = HTMLDocument(string: html)
        for node in htmlDocument.nodes(matchingSelector: "table tbody tr td a ").dropFirst() {
            
            let link = node.attributes
            let linkToReservations = EndpointsConstants.MainEndpoint.baseURL + link["href"]!
            hrefs.insert(linkToReservations)
        }
        
        if hrefs.contains(duzaSalaString) {
            hrefs.remove(duzaSalaString)
        } else if hrefs.contains(malaSalaString) {
            hrefs.remove(malaSalaString)
        }
        
        
        
        return hrefs
    }
    
    func getMyReservations(fromHTML urlString: String) -> String {
        
        let myHTMLString = getContent(ofHTML: urlString)
        var result2 = ""
        
        if let  lowerBound = myHTMLString.range(of: "<h2>Archiwum rezerwacji"), let upperBound = myHTMLString.range(of: "Aktualne rezerwacje</h2>"){
            
            let result = myHTMLString.substring(to: lowerBound.lowerBound)
            
            result2 = result.substring(from: upperBound.upperBound)
            
            return result2
        }
        
        return result2
        
    }
    
    
    func getContent(ofHTML urlString: String) -> String {
        do  {
            
            let htmlString = try String(contentsOf: URL(string: urlString)!, encoding: .utf8)
            return htmlString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        } catch let error {
            return "Error: \(error)"
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].sectionTrainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.trainingCell, for: indexPath) as! TrainingTableViewCell
        let training = sections[indexPath.section].sectionTrainings[indexPath.row]
        cell.trainingNameLabel.text = training.titleWithName
        cell.colorLabel.backgroundColor = UIColor(hexString: training.bgColor).flatten()
        
        cell.colorLabel.layer.cornerRadius = cell.colorLabel.frame.size.width / 2
        cell.colorLabel.clipsToBounds = true
        
        cell.shortcutLabel.text = String(training.title[training.title.startIndex])
        
        cell.hourLabel.text = training.hour
        cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
        cell.dateLabel.text = "Data: " + training.date
        
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = sections[section].sectionTitle
        let nameOfTheWeek = getNameOfTheWeekFrom(dateAsString: date)!
        let title = date + "(\(nameOfTheWeek))"
        return title
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
}





