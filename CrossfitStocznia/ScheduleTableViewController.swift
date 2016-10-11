//
//  ScheduleTableViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 06.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

  var trainings = [Training]()
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
      
 
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        let cellNib = UINib(nibName: TableViewCellIdentifiers.trainingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.trainingCell)
        
        let data = parseJSON(performRequest(calendarURL)!)
        trainings = parseArraysOfDictionaries(data!)
        
        tableView.reloadData()
      
    }
  
  let calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=2016-10-03&date_next=2016-10-17&date_start=2016-10-10&date_end=2016-10-16"
  
  
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
      else {return nil }
    
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
    } catch {
      print("JSON error: \(error)")
      return nil
    }
  }
  
  func parseArraysOfDictionaries(_ array: [[String:AnyObject]])  -> [Training] {
    
    var trainings = [Training]()
    
    for dictionary in array{
      
      let training = Training()
      let title  = dictionary["title"] as! String
      let hour = dictionary["hour"] as! String
      let date = dictionary["date"] as! String
      let dateID  = dictionary["date_id"] as! String
      training.dateID = dateID
      training.placesLeft = dictionary["places"] as! Int
      training.bgColor = dictionary["bg"] as! String
      training.hour = hour.substring(to: "17:00:00".index("17:00:00".endIndex, offsetBy: -3))
      //print(training.hour)1
      training.titleWithName = title
      training.title = deleteName(ofTheCoach: title)
      training.coachName = getName(OfTheCoach: title)
      training.date = date
      training.nameOfTheWeek = getNameOfTheWeekFrom(dateAsString: date)!
      training.id = dictionary["id"] as! String
      training.dateAsDateType = fromStringToDate(dateString: dateID)
      
      trainings.append(training)
      
      trainings.sort(by: { $0.dateAsDateType < $1.dateAsDateType })
      
      
      
    }
    
    
    
    return trainings
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainings.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.trainingCell, for: indexPath) as! TrainingTableViewCell
      let training = trainings[(indexPath as NSIndexPath).row]
      cell.trainingNameLabel.text = training.titleWithName
      cell.backgroundColor = UIColor(hexString: training.bgColor)
      cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
      cell.dateLabel.text = "Data: " + training.date
      
      return cell

    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let detailViewController = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
      let tappedCell = trainings[indexPath.row]
      detailViewController.training = tappedCell
      
    }
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

func fromStringToDate(dateString: String) -> Date {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm"
  
  return dateFormatter.date(from: dateString)!
  
}




