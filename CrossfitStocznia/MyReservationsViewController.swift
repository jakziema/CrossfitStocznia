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
  
  @IBOutlet weak var webView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      
      
     
      
      let myURLString = "http://crossfitstocznia.reservante.pl/client/orders"
      guard let myURL = URL(string: myURLString) else {
        print("Error: \(myURLString) doesn't seem to be a valid URL")
        return
      }
      
      do {
        let myHTMLString = try String(contentsOf: myURL, encoding: .utf8).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        
        
        if let  lowerBound = myHTMLString.range(of: "<h2>Archiwum rezerwacji") {
          if let upperBound = myHTMLString.range(of: "Aktualne rezerwacje</h2>") {
            let result = myHTMLString.substring(to: lowerBound.lowerBound)
            let result2 = result.substring(from: upperBound.upperBound)
            //print(result2)
            parseHTML(html: result2)
            
            
            
            
          }
          
        }
        
      } catch let error {
        print("Error: \(error)")
      }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  func parseHTML(html: String) {
    let htmlDocument = HTMLDocument(string: html)
    for node in htmlDocument.nodes(matchingSelector: "table tbody tr td a ").dropFirst() {
      let link = node.attributes
      //print(link["href"]!)
      let linkToReservations = "http://crossfitstocznia.reservante.pl" + link["href"]!
      print(linkToReservations)
          }
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
