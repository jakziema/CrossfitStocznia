//
//  ScheduleTableViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 06.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit
import HTMLReader
import SwiftSoup


class ScheduleTableViewController: UITableViewController {
    
    var trainings = [Training]()
    var sections = [Section]()
    var bookings = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        for id in bookings {
            print("MOJA REZERWACJA: \(id)")
        }
        
        
        
        let data = parseJSON(performRequest(getPresentCalendarURL())!)
        sections = parseArraysOfDictionaries(data!)
        
        
        tableView.reloadData()
        
        
        
    }
    
    //getting classes for two upcoming weeks
    func getPresentCalendarURL()-> String {
        var calendarURL = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let weekLater = today.addingTimeInterval(7 * 24 * 60 * 60)
        let twoWeeksLater = today.addingTimeInterval(14 * 24 * 60 * 60)
        let weekEarlier = today.addingTimeInterval(-7 * 24 * 60 * 60)
        
        calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=\(dateFormatter.string(from: weekEarlier))&date_next=\(dateFormatter.string(from: twoWeeksLater))&date_start=\(dateFormatter.string(from: today))&date_end=\(dateFormatter.string(from: weekLater))"
        
        
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
        
        for (index,dictionary) in array.enumerated() {
            
            
            
            let training = Training()
            let title  = dictionary["title"] as! String
            let hour = dictionary["hour"] as! String
            let date = dictionary["date"] as! String
            let dateID  = dictionary["date_id"] as! String
            if let orders = dictionary["orders"] as? [[String: Any]] {
                for order2 in orders {
                    
                    if let id = order2["id"] as? String, let user_id = order2["user_id"] as? String {
                        print("ID: \(id) USER ID: \(user_id)" )
                        
                    }
                }
            }
            
            
            
            
            //let orders_2 = dictionary["orders_2"] as! [[String: Any]]
            //let orders_5 = dictionary["orders_5"] as! [[String:Any]]
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
                
            } else {
                
                for section in sections {
                    if (section.sectionTitle == date) {
                        zmienna =  false
                        sections.sort(by: { $0.sectionDateAsType < $1.sectionDateAsType })
                        section.sectionTrainings.append(training)
                        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].sectionTrainings.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.trainingCell, for: indexPath) as! TrainingTableViewCell
        let training = sections[indexPath.section].sectionTrainings[indexPath.row]
        cell.trainingNameLabel.text = training.titleWithName
        cell.backgroundColor = UIColor(hexString: training.bgColor)
        cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
        cell.dateLabel.text = "Data: " + training.date
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = sections[section].sectionTitle
        let nameOfTheWeek = getNameOfTheWeekFrom(dateAsString: date)!
        let title = date + "(\(nameOfTheWeek))"
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
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






