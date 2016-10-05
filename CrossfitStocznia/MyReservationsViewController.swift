//
//  MyReservationsViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class MyReservationsViewController: UIViewController {
  
  @IBOutlet weak var myReservationsWebView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      download_request()
  
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func download_request()
  {
    let url:URL = URL(string: "http://crossfitstocznia.reservante.pl/auth")!
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    let paramString = "email="+"ziemannjakub@gmail.com"+"&password="+"Tczew22011994"+"&submit_login= "
    request.httpBody = paramString.data(using: String.Encoding.utf8)
    
    
    let task = session.downloadTask(with: request as URLRequest, completionHandler: {
      (
      location, response, error) in
      
      guard let _:URL = location, let _:URLResponse = response  , error == nil else {
        print("error")
        return
      }
      
      let urlContents = try! NSString(contentsOf: location!, encoding: String.Encoding.utf8.rawValue)
      
      guard let _:NSString = urlContents else {
        print("error")
        return
      }
      
      print(urlContents)
      let url2 = location!
      self.myReservationsWebView.loadRequest(URLRequest(url: url2))
    })
    task.resume()
    
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
