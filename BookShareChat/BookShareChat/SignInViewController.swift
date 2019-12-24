//
//  SignInViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/2/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignInViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        
        let userID = Auth.auth().currentUser?.uid
        
        
        if userID != nil{
            
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                
                print("User Has auto logged in! ",username)
                
                var myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                var appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = myTabBar
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else {
            print(">>>>>>>>>> UserID is nil")
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: Email.text!) { error in
            // ...
        }

    }
    @IBAction func login(_ sender: Any) {
        
        
       
        
            Auth.auth().signIn(withEmail: self.Email.text!, password: self.Password.text!) { (user, error) in
                if user != nil {
                    print("User Has Loged in!")
                    
                    var myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                    var appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = myTabBar
                    /*
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeview") as! HomeViewController
                    self.present(homeViewController, animated: true, completion: nil)
                    */
                }
                if error != nil {
                    print(":(")
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
