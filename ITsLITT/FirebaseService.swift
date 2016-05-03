
//
//  FirebaseService.swift
//
//  Created by Cesa Salaam on 4/4/16 ..
//  Copyright © 2016 CesaSalaam. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: NSObject {
    //
    
    static let firebase = FirebaseService() //Creating a singleton
    
    static var BASE_URL = "https://cesatest.firebaseio.com" //main reference to firebase database
    
    let mainRef = Firebase(url: BASE_URL)
    
    let userRef = Firebase(url: BASE_URL).childByAppendingPath("App_Users") //reference for the path of users in the database
    
    let imageItemsRef = Firebase(url: BASE_URL).childByAppendingPath("imageItems")//reference for the path of images in the database
    
    var publicImages = [image]() //array of type image
    
    
    // array of image information
    var images = [NSDictionary]()
    
    
    //
    // this will get the imageItems from the firebase instance and will get watch for
    // any changes to the data and immediately update the results
    //
    func setupImageItems( callback: (() -> Void)!) {
        
        imageItemsRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our images data.
            
            self.images.removeAll();
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    self.images.insert((snap.value as! NSDictionary),atIndex: 0)
                }
                
                callback()
            }
        })
    }
    
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        // A User is born.
        userRef.childByAppendingPath(uid).setValue(user)
    }
    
    func getImageItems () -> [NSDictionary] {
        return images
    }
    
    
    func removeImageItemObserver() {
        imageItemsRef.removeAllObservers()
    }
    
    func saveImageToFirebase(savedImage:UIImage, title:String, uid:String) {
        //Function to save image to database under the imageItemsRef path
        let data = UIImageJPEGRepresentation(savedImage, 0.5)
        let dataStr = data!.base64EncodedStringWithOptions([.Encoding64CharacterLineLength])
        imageItemsRef.childByAppendingPath(uid).childByAutoId().setValue(["name" :title, "data": dataStr, "id" : uid], withCompletionBlock: {(error,fb)  in
            if (error != nil) {
                print(error)
            }
        })
    }
}