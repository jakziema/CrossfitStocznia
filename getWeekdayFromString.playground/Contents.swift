//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



var test = "Class 1+2 (adfdafs)"


if let match = test.range(of: "\\((.*?)\\)", options: .regularExpression) {
  print(test.substring(with: match))
  
}

func deleteName(ofTheCoach text: String) -> String {
  
  if let range = text.range(of: "(") {
    var title = text.substring(to: range.lowerBound)
    return title
  }
}

print(deleteName(ofTheCoach: test))


