//
//  SignUpViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/2/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Roll: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        ref = Database.database().reference()
        
        
        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.Email.text!, password: self.Password.text!) { (user, error) in
            if user != nil {
                
                let userID = Auth.auth().currentUser?.uid
                print(">>>>>>>>>> User Has Signed up!")
                self.ref.child("users").child(userID!).child("name").setValue(self.Name.text!)
                self.ref.child("users").child(userID!).child("Roll").setValue(self.Roll.text!)
                self.ref.child("users").child(userID!).child("Email").setValue(self.Email.text!)
                
                if userID != nil{
                    self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let username = value?["name"] as? String ?? ""
                        
                        print("User Has Signed up! ",username)
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                else {
                    print(">>>>>>>>>> UserID is nil")
                }
                
                

                
                var myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                var appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = myTabBar
            }
            if error != nil {
                print(":(",error)
            }
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
