//
//  ViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 18.05.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class TrainingsTableViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var trainings = [Training]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
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
  
  
}



extension TrainingsTableViewController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainings.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.trainingCell, for: indexPath) as! TrainingTableViewCell
    let training = trainings[(indexPath as NSIndexPath).row]
    cell.trainingNameLabel.text = training.title
    cell.backgroundColor = UIColor(hexString: training.bgColor)
    cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
    cell.dateLabel.text = "Data: " + training.date
    
    return cell
    
    
  }
}

extension UIColor {
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
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

