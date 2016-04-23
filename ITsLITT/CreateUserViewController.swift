//
//  CreateUserViewController.swift
//  ITsLITT
//
//  Created by Cesa Salaam on 4/12/16.
//  Copyright © 2016 CesaSalaam. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {

    //MARK: Outlets and Actions
    @IBOutlet var password: UITextField!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var emailAdd: UITextField!
    
    
    @IBAction func createAccount(sender: AnyObject) {
        
        //Action for create an Account button click.
        
        //This actions takes whats stored in the textfield and creates a new user.
        createUser(emailAdd.text!, password: password.text!, username: username.text!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        //resigns keyboard when background is tapped
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //MARK: user function
    func createUser(email: String, password: String, username: String){
        //function that creates user
        if (username != "" && email != "" && password != ""){
            
            // Set Email and Password for the New User.
            FirebaseService.firebase.userRef.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    print(error.description)
                    // alert user that there was an error
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                } else {
                    
                    // Create and Login the New User with authUser
                    FirebaseService.firebase.userRef.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!, "email": email, "username": username]
                        
                        // Seal the deal in DataService.swift.
                      FirebaseService.firebase.createNewAccount(authData.uid, user: user)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    // Enter the app.
                    self.performSegueWithIdentifier("toMainTable", sender: nil)
                }
            })
            
        } else {
            //Alert user that there was an error
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    
    func signupErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        //creates an alert
        let alert = UIAlertView(
            title: NSLocalizedString("Create account failed", comment: "Sign account failed"),
            message: message,
            delegate: nil,
            cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
        )
        alert.show()
    }
}
