//
//  LoginViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  @IBAction func login() {
    let login = ["user": loginTextField.text!, "pass":passwordTextField.text!, "submit_login": ""]
    
    let url = NSURL(string: "http://crossfitstocznia.reservante.pl/auth")!
    
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url as URL)
    
    do {
      // JSON all the things
      let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
      
      // Set the request content type to JSON
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      
      // The magic...set the HTTP request method to POST
      request.httpMethod = "POST"
      
      // Add the JSON serialized login data to the body
      request.httpBody = auth
      
      // Create the task that will send our login request (asynchronously)
      let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        // Do something with the HTTP response
        print("Got response \(response) with error \(error)")
        print("Done.")
      })
      
      // Start the task on a background thread
      task.resume()
      
    }
    catch {
      // Handle your errors folks...
      print("Error")
    }
  }
  


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      
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
