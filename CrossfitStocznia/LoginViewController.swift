//
//  LoginViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 05.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let httpManager = HttpManager()
    let loginMethod = MyReservationsViewController()
    var crossfitStoczniAuth = EndpointsConstants.LoginEndpoint.baseURL
    
    
    
    @IBAction func login() {
        
        httpManager.loginWithParameters2(email: loginTextField.text!, password: passwordTextField.text!, token: loginMethod.getTokenValue(), urlString: crossfitStoczniAuth){content in
            
            if content.contains("Niepoprawny") {
                
                print(Thread.isMainThread)
                
                let alertController = UIAlertController(title: "Error", message: "Niepoprawny login lub hasło", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } else {
                
                KeychainWrapper.standard.set(self.loginTextField.text!, forKey: "email")
                KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: "password")
                KeychainWrapper.standard.set(true, forKey: "savedCredentials")
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "toTrainingsTable", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if  KeychainWrapper.standard.bool(forKey: "savedCredentials") != nil {
            if (KeychainWrapper.standard.string(forKey: "email") != nil) && (KeychainWrapper.standard.string(forKey: "password") != nil) {
                httpManager.loginWithParameters2(email: KeychainWrapper.standard.string(forKey: "email")!, password: KeychainWrapper.standard.string(forKey: "password")!, token: loginMethod.getTokenValue(), urlString: crossfitStoczniAuth) {content in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.performSegue(withIdentifier: "toTrainingsTable", sender: self)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
