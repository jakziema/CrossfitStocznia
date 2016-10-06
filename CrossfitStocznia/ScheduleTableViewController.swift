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
      
 
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        let cellNib = UINib(nibName: TableViewCellIdentifiers.trainingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.trainingCell)
        
        let data = parseJSON(performRequest(calendarURL)!)
        trainings = parseArraysOfDictionaries(data!)
        
        tableView.reloadData()
      
    }
  
  let calendarURL = "http://crossfitstocznia.reservante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=2016-09-26&date_next=2016-10-10&date_start=2016-10-03&date_end=2016-10-09"
  
  
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
      let name = dictionary["title"] as! String
      let hour = dictionary["hour"] as! String
      let date = dictionary["date"] as! String
      let dateID = dictionary["date_id"] as! String
      let freePlaces = dictionary["places"] as! Int
      let bgColor = dictionary["bg"] as! String
      
      training.title = name
      training.hour = hour
      training.date = date
      training.dateID = dateID
      if freePlaces != 0 {
        training.placesLeft = freePlaces
      } else {
        training.placesLeft = 0
      }
      training.bgColor = bgColor
      
      print(training.placesLeft)
      
      trainings.append(training)
      
      
      
      
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
      cell.trainingNameLabel.text = training.title
      cell.backgroundColor = UIColor(hexString: training.bgColor)
      cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
      cell.dateLabel.text = "Data: " + training.date
      
      return cell

    }
 

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


