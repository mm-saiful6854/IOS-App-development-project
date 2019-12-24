//
//  AddViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/2/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

extension Date {
    func toMillis() -> String! {
        return String(self.timeIntervalSince1970 * 1000)
    }
}

class AddViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    // other code
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myBookTitle: UITextField!
    @IBOutlet weak var myBookAuthor: UITextField!
    @IBOutlet weak var myBookLanguage: UITextField!
    @IBOutlet weak var myBookCategory: UITextField!
    
    @IBOutlet weak var myBookDescription: UITextView!
    
    var ref: DatabaseReference!
    var optimizedImageData: Data!
    var imageLoaded: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        imageLoaded = false
        self.myImageView.image = UIImage(named: "book-image")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        profileImagePicker.mediaTypes = [kUTTypeImage as String]
        profileImagePicker.delegate = self
        present(profileImagePicker, animated: true, completion: nil)
    }
    func showAlert(msg: String) {
        
        let alertController = UIAlertController(title: "Add Book", message:
            msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
 
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any])
    {
        /// The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.myImageView.image = selectedImage
        
        
        if let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageDataNew = profileImage.jpegData(compressionQuality: 0.1)
        {
            // upload image from here
            imageLoaded = true
            optimizedImageData = optimizedImageDataNew
        
        }
        picker.dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }

    func uploadProfileImage(imageData: Data, id: String)
    {
        
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("Books").child(id)
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
               //self.userProfileImageView.image = UIImage(data: imageData)
                self.showAlert(msg: "Yeah! Book successfully uploaded!")
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
    
    
    
    @IBAction func addBookSaveBtn(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        
        if(optimizedImageData==nil){
            self.showAlert(msg: "Please insert cover photo of your book!")
            return
        }
        let key = ref.child("Books").childByAutoId().key
        
        if(key != nil)
        
        
        {
            let post = ["uid": userID,
                        "language": self.myBookLanguage.text!,
                        "author": self.myBookAuthor.text!,
                        "title": self.myBookTitle.text!,
                        "category": self.myBookCategory.text!,
                        "description": self.myBookDescription.text!]
            
            let childUpdates = ["/Books/\(key ?? "")": post]
            
            ref.updateChildValues(childUpdates)
            if(imageLoaded == true)
            {
                uploadProfileImage(imageData: optimizedImageData, id: key!)

            }
        }
        else {
            print(">>>>>>>>>>>>>>>>> key is nil")
        }
        

        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
