//
//  MyReservationsViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit
import HTMLReader

class MyReservationsViewController: UIViewController {
  
  var myReservations = [ParsedTraining]()
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let myHTMLString = getContent(ofHTML: "http://crossfitstocznia.reservante.pl/client/orders").trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    
    print("ZAWARTOSC HTML: \(myHTMLString)")
    
    
    if let  lowerBound = myHTMLString.range(of: "<h2>Archiwum rezerwacji") {
      if let upperBound = myHTMLString.range(of: "Aktualne rezerwacje</h2>") {
        let result = myHTMLString.substring(to: lowerBound.lowerBound)
        let result2 = result.substring(from: upperBound.upperBound)
        
        print("REZERWACJE:  \(result2)")
        parseHTML(html: result2)
        
      }
    }
    
    
    
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    func getTokenValue() {
        let myHTMLString = getContent(ofHTML: "http://crossfitstocznia.reservante.pl/auth").trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        print("Zawartosc html: \(myHTMLString)")
    }
  
  
  func parseHTML(html: String) {
    let htmlDocument = HTMLDocument(string: html)
    for node in htmlDocument.nodes(matchingSelector: "table tbody tr td a ").dropFirst() {
      let link = node.attributes
      print(link["href"]!)
      let linkToReservations = "http://crossfitstocznia.reservante.pl" + link["href"]!
      print(linkToReservations)
    }
  }
    
    
    
  
  
  
  
  func getContent(ofHTML urlString: String) -> String {
    do  {
      
      let htmlString = try String(contentsOf: URL(string: urlString)!, encoding: .utf8)
      return htmlString
    } catch let error {
      return "Error: \(error)"
    }
  }
  
  
  
}
