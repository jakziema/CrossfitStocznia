//
//  ViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 18.05.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
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

 
  
 let calendarURL = "http://crossfitstocznia.rezervante.pl/xhr/calendars_orders?calendar_id=665&worktime=events&interval=30&date_prev=2016-05-09&date_next=2016-05-23&date_start=2016-05-16&date_end=2016-05-22"
  
  
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
  
  func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
    }
    
    if ((cString.characters.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  struct TableViewCellIdentifiers {
    static let trainingCell = "TrainingCell"
    
  }


}



extension ViewController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainings.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.trainingCell, for: indexPath) as! TrainingTableViewCell
    let training = trainings[(indexPath as NSIndexPath).row]
    cell.trainingNameLabel.text = training.title
    cell.backgroundColor = hexStringToUIColor(training.bgColor) 
    cell.placesLeftLabel.text = "Ilość miejsc: \(training.placesLeft)"
    
    return cell
    
    
  }
}

