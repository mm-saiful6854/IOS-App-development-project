//
//  AccountViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/3/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet var userName: UILabel!

    @IBOutlet var userEmail: UILabel!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        if userID != nil{
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? "Team RASS"
                let useremail = value?["Email"] as? String ?? "cse.repon@gmail.com"
                
                self.userName.text   = username
                self.userEmail.text   = useremail
                
                print("User account loaded! ",username)
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else {
            print(">>>>>>>>>> UserID is nil")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonTappd(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
            
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController") as! SignInViewController
            self.present(newViewController, animated: true, completion: nil)
            
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
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
