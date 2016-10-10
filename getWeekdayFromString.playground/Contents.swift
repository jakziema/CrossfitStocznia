//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


  func getNameOfTheWeekFrom(dateAsString date: String) -> String? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    if let stringAsDate = formatter.date(from: date.capitalized(with: NSLocale.current)) {
      let nameOfTheWeekFormatter = DateFormatter()
      nameOfTheWeekFormatter.dateFormat = "EEEE"
      return nameOfTheWeekFormatter.string(from: stringAsDate)
      
    } else {
      return nil
    }
  }
print(getNameOfTheWeekFrom(dateAsString: "2016-10-10")!)


func getDayOfWeek(_ today:String) -> String? {
  let weekdays = [
    "Niedziela",
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
    "Sobota"
  ]
  
  let formatter  = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  if let todayDate = formatter.date(from: today) {
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
     return weekdays[weekDay - 1]
  } else {
    return nil
  }
}

print(getDayOfWeek("10-11-2016"))


