//
//  DetailViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 10.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit
import AVFoundation


class DetailViewController: UIViewController {
  
  var training: Training!
  
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var coachImage: UIImageView!
  @IBOutlet weak var coachNameLabel: UILabel!
  @IBOutlet weak var trainingNameLabel: UILabel!
  @IBOutlet weak var trainingHourLabel: UILabel!
  @IBOutlet weak var trainingDateLabel: UILabel!
  @IBOutlet weak var makeABookingButton: UIButton!
    
    var successSoundEffect: AVAudioPlayer!
    
    
    
    
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func makeABooking() {
    let bookingString = "http://crossfitstocznia.reservante.pl/calendars/reservation/665/\(training.dateID)/\(training.id)"
    
    var request = URLRequest(url: URL(string: bookingString)!)
    request.httpMethod = "POST"
    let postString = "info=" + "" + "&submit=" + "" 
    
    request.httpBody = postString.data(using: String.Encoding.utf8);
    
    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        let path = Bundle.main.path(forResource: "success.aif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.successSoundEffect = sound
            sound.play()
        } catch {
            print("Couldn't play sound")
        }
        

      if error != nil {
        return
      }
    }
    
    task.resume()
    
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //view.backgroundColor = UIColor.clear
    
    //rounded corners
    popupView.layer.cornerRadius = 10
    
    
    
    
    switch training.coachName {
    case "Adam":
        coachImage.image =  UIImage(named:"adam-borkowski")
    case "Krzysiek":
        coachImage.image =  UIImage(named:"krzysztof-malkowski")
    case "Tomek":
        coachImage.image =  UIImage(named:"tomek-kolicki")
    case "Pawel":
        coachImage.image =  UIImage(named:"pawel-szuba")
    case "Ewa":
        coachImage.image =  UIImage(named:"ewa-koscielniak")
    case "Marcin":
        coachImage.image =  UIImage(named:"marcin-zuzanski")
    case "Leo":
        coachImage.image =  UIImage(named:"marcin-leszkowicz")
    case "Adrian":
        coachImage.image =  UIImage(named:"adrian-lopatynski")
    case "Paweł":
        coachImage.image = UIImage(named: "pawel-szuba")
    default:
        coachImage.image = UIImage(named: "logo-red")
    }
    
    //coachImage.layer.cornerRadius = coachImage.frame.size.width / 2
    //coachImage.clipsToBounds = true
    
    
    
    //Gesture Recognizing outside popup
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    print(training.coachName)
    
    
    updateUI()
    
  }
  
  func updateUI() {
    trainingNameLabel.text = training.title
    coachNameLabel.text = training.coachName
    trainingHourLabel.text = training.hour
    trainingDateLabel.text = training.date
    
    print(training.date)
    
  }
  
  

}

//
extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
}

// get back to previous screen tapping outside popup
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

