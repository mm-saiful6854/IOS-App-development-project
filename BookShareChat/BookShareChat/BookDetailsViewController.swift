//
//  BookDetailsViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/4/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class BookDetailsViewController: UIViewController {

    
    
    
    @IBOutlet var btitle: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var author: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var bdescription: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var ChatButton: UIButton!
    @IBOutlet var DeleteButton: UIButton!
    
    var bookkey: String!
    var booktitle: String!
    var bookuser: String!
    var bookusername: String!
    var bookauthor: String!
    var bookdescription: String!
    var bookcategory: String!
    var isMyBook: Bool!
    var allUsers: DataSnapshot!
    var bookimage: UIImage!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        self.btitle.text = booktitle!
        self.author.text = bookauthor!
        self.category.text = bookcategory!
        self.bdescription.text = bookdescription!
        self.image.image = bookimage!
        self.user.text = bookusername!
        if(isMyBook){
            ChatButton.isHidden = true
        }
        else{
            DeleteButton.isHidden = true
        }
        
        print(booktitle)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.ref.child("Books").child(bookkey!).removeValue{ (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
                else{
                    self.showAlert(msg: "Book Deleted Successfully!")
                    self.DeleteButton.isHidden = true
                }
            }
    }
    
    func showAlert(msg: String) {
        
        let alertController = UIAlertController(title: "My Book", message:
            msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
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
