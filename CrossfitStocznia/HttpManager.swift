//
//  HttpManager.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import Foundation
import UIKit

class HttpManager  {
    
    
    func loginWithParameters2(email:String, password: String,token: String, urlString: String, completionHandler: @escaping (_ content: String) -> ())  {
        
        let myUrl = URL(string: urlString);
        
        
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let postString = "sign_in_form[_token]=" + token + "&sign_in_form[email]="+email+"&sign_in_form[password]="+password+"&sign_in_form[submit]"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?)  in
            
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            let content2 = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            completionHandler(content2)
            
            
        }
        task.resume()
        
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






