//
//  LogInViewController.swift
//  ITsLITT
//
//  Created by Lifoma Salaam on 4/12/16.
//  Copyright © 2016 CesaSalaam. All rights reserved.
//

import UIKit
import Firebase
class LogInViewController: UIViewController {
    
    //MARK: outlets and actions
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBAction func Login(sender: AnyObject) {
        
        let email = username.text
        
        let passwordText = password.text
        
        if email != "" && passwordText != "" {
            
            // Login with the Firebase's authUser method
            
            FirebaseService.firebase.userRef.authUser(email, password: passwordText, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else {
                    // Be sure the correct uid is stored.
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // Enter the app!
                    
                    self.performSegueWithIdentifier("toTable", sender: nil)
                }
            })
            
        } else {
            
            // There was a problem
            
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
        }
    }
    
    func loginErrorAlert(title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Views
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewDidLoad(){
        FirebaseService.firebase.mainRef.observeAuthEventWithBlock({ authData in
            if authData != nil {
                self.performSegueWithIdentifier("toTable", sender: nil)
            } else {
                // No user is signed in
            }
        })
    }
}
