//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
//dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
let date = dateFormatter.string(from: Date())
print(date)





