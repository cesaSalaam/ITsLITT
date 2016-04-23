//
//  ViewController.swift
//  ITsLITT
//
//  Created by Cesa Salaam on 4/5/16.
//  Copyright © 2016 CesaSalaam. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: outlets, actions and variables
    let imagePicker = UIImagePickerController()
    
    @IBAction func logout(sender: AnyObject) {
        //action to log out of the app.
        FirebaseService.firebase.mainRef.unauth()
        FirebaseService.firebase.publicImages.removeAll()
        performSegueWithIdentifier("logingout", sender: nil)
    }
    @IBAction func add(sender: AnyObject) {
        //action to open of the phot gallery
        //accesses the photo library
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: table view functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //sets number of sections in table
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // returns the number of rows in section
        return FirebaseService.firebase.publicImages.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //loads data into cells
        let cell: customCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! customCell
        
        cell.cellImage.image = FirebaseService.firebase.publicImages[indexPath.row].image!.image
        return cell
    }
}

//MARK: image picker and getting data
extension ViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        FirebaseService.firebase.saveImageToFirebase(image, title: "Image_SAving",uid: FirebaseService.firebase.mainRef.authData.uid)
        
        self.getImages() //calling getImages function
        
        FirebaseService.firebase.setupImageItems({() -> Void in
            self.tableView.reloadData() // reloading table in callback
        })
    }
    
    func getImages(){
        //function to get images from database and append them to the firebase.publicImages
        FirebaseService.firebase.publicImages.removeAll() // resetting the public images so that thereis no duplicate
        
        let ref = Firebase(url: "https://cesatest.firebaseio.com/imageItems/\(FirebaseService.firebase.mainRef.authData.uid)")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let Image = image() //creating new image object
            let data = NSData(base64EncodedString:  snapshot.value.objectForKey("data") as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters ) //converting string from firebase to NSData
            let img = UIImage(data: (data)!) // changing data to image
            Image.image = UIImageView(image: img) //adding img to Image object
            FirebaseService.firebase.publicImages.append(Image) // adding Image to publicImages
        })
    }
}

