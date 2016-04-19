//
//  CreateUserViewController.swift
//  ITsLITT
//
//  Created by Lifoma Salaam on 4/12/16.
//  Copyright © 2016 CesaSalaam. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {

    //MARK: Outlets and Actions
    @IBOutlet var password: UITextField!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var emailAdd: UITextField!
    
    //Action for create an Account button click.
    
    //This actions takes whats stored in the textfield and creates a new user.
    
    @IBAction func createAccount(sender: AnyObject) {
        
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        //Variables hold
        let userNameText = username.text
        let passwordText = password.text
        let emailText = emailAdd.text
        
        var finalUserNameText = ""
        var finalPasswordText = ""
        var finalEmailAddText = ""
        if userNameText!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            // this statement stops user from being able to add white spaces to table
            return
        }
        if username.text![username.text!.endIndex.predecessor()] == " "{
            print(userNameText?.characters.count)
            
            for char in username.text!.characters{
                if char != " "{
                    finalUserNameText.append(char)
                }
            }
        }
        if password.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            // this statement stops user from being able to add white spaces to table
            return
        }
        
        if password.text![password.text!.endIndex.predecessor()] == " "{
            
            for char in password.text!.characters{
                
                if char != " "{
                    
                    finalPasswordText.append(char)
                    
                }
            }
        }
        
        if emailText!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            // this statement stops user from being able to add white spaces to table
            return
        }
        if emailText![emailText!.endIndex.predecessor()] == " "{
            for char in emailText!.characters{
                
                if char != " "{
                    
                    finalEmailAddText.append(char)
                    
                }
            }
            
            createUser(finalEmailAddText, password: finalPasswordText, username: finalUserNameText)
            
            return
            
        }
        createUser(emailAdd.text!, password: passwordText!, username: userNameText!)
    }
}
//MARK: Other functions
extension CreateUserViewController{
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
        let alert = UIAlertView(
            title: NSLocalizedString("Create account failed", comment: "Sign account failed"),
            message: message,
            delegate: nil,
            cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
        )
        alert.show()
    }
    

}
