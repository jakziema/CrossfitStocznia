//
//  MyReservationsViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class MyReservationsViewController: UIViewController {
  
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
        let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
        print("HTML : \(myHTMLString)")
      } catch let error {
        print("Error: \(error)")
      }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
