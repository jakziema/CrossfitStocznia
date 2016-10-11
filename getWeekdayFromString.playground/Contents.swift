//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm"
//dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
let date = dateFormatter.date(from: "2016_10_05_17_00")!



