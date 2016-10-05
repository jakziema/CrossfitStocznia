//
//  HttpManager.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import Foundation

class HttpManager {
  
  
  
  func loginWithParameters(email: String, password: String, urlString: String) {
    let url:URL = URL(string: urlString)!
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    let paramString = "email="+email+"&password="+password+"&submit_login= "
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
      
    })
    task.resume()
    
  }

}
