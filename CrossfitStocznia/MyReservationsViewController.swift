//
//  MyReservationsViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit
import HTMLReader
import SwiftSoup

class MyReservationsViewController: UIViewController {
    
    var myReservations = [ParsedTraining]()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTokenValue() -> String {
        
        do {
            let myHTMLString = getContent(ofHTML: EndpointsConstants.TokenValueEndpoint.baseURL)
            
            let doc: Document = try! SwiftSoup.parse(myHTMLString)
            let form: Elements = try! doc.getElementsByTag("form")
            let input = try! form.select("input").first()!
            let tokenValue = try! input.attr("value")
            
            return tokenValue
            
        } catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }
    }
    
    func getTrainingsIDs(hrefs: Set<String>)-> [String] {
        var ids = [String]()
        
        for href in hrefs {
            let id = href.components(separatedBy: "show/")[1]
            ids.append(id)
        }
        
        return ids
    }
   
    
    
    func parseHTML(html: String)-> Set<String> {
        
        let duzaSalaString = "http://crossfitstocznia.reservante.pl/calendars/665"
        let malaSalaString = "http://crossfitstocznia.reservante.pl/calendars/666"
        
        var hrefs = Set<String>()
        
        let htmlDocument = HTMLDocument(string: html)
        for node in htmlDocument.nodes(matchingSelector: "table tbody tr td a ").dropFirst() {
            
            let link = node.attributes
            let linkToReservations = EndpointsConstants.MainEndpoint.baseURL + link["href"]!
            hrefs.insert(linkToReservations)
        }
        
        if hrefs.contains(duzaSalaString) {
                hrefs.remove(duzaSalaString)
        } else if hrefs.contains(malaSalaString) {
            hrefs.remove(malaSalaString)
        }
        
        
        
        return hrefs
    }
    
    func getMyReservations(fromHTML urlString: String) -> String {
        
        let myHTMLString = getContent(ofHTML: urlString)
        var result2 = ""
        
        if let  lowerBound = myHTMLString.range(of: "<h2>Archiwum rezerwacji"), let upperBound = myHTMLString.range(of: "Aktualne rezerwacje</h2>"){
            
            let result = myHTMLString.substring(to: lowerBound.lowerBound)
            
            result2 = result.substring(from: upperBound.upperBound)
            
            return result2
        }
        
        return result2
        
    }
    
    
    func getContent(ofHTML urlString: String) -> String {
        do  {
            
            let htmlString = try String(contentsOf: URL(string: urlString)!, encoding: .utf8)
            return htmlString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        } catch let error {
            return "Error: \(error)"
        }
    }
    

    func parseHrefAsBooking(href: String) {
        let myHTMLString = getContent(ofHTML: href)
        let doc: Document = try! SwiftSoup.parse(myHTMLString)
    }
    
    
    
    
    
    
    
    
    
    
}
