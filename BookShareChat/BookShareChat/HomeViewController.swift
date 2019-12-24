//
//  HomeViewController.swift
//  BookShareChat
//
//  Created by cse.repon on 12/2/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    var bookkey: [String] = []
    var booktitle: [String] = []
    var bookuser: [String] = []
    var bookusername: [String] = []
    var bookauthor: [String] = []
    var bookdescription: [String] = []
    var bookcategory: [String] = []
    var myBookIndex: [Int] = []
    var isMyBook: [Bool] = []
    var allUsers: DataSnapshot!
    
    @IBOutlet var myBookButton: UIButton!
    
    var ref: DatabaseReference!
    var optimizedImageData: Data!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        

        
        loadBooks()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadBooks()
    }
    
    var isMyBookTapped = false
    @IBAction func myBookTapped(_ sender: Any) {
        if(isMyBookTapped){
            isMyBookTapped = false
            showBook()
            myBookButton.setTitle("My Book", for: UIControl.State.normal)
        }
        else{
            isMyBookTapped = true
            showBook()
            myBookButton.setTitle("All Book", for: UIControl.State.normal)
        }
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
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
    
    
    
    func loadBooks(){

     
            self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.allUsers = snapshot
                let refBook = Database.database().reference()
                let userID = Auth.auth().currentUser?.uid
                
                self.bookkey = []
                self.booktitle = []
                self.bookuser = []
                self.bookusername = []
                self.bookauthor = []
                self.bookdescription = []
                self.bookcategory = []
                self.myBookIndex = []
                

                refBook.child("Books").observeSingleEvent(of: .value, with: { (snapshot) in
                    var count = 0
                    for child in snapshot.children {
                        let mainChild = child as! DataSnapshot
                        let key = mainChild.key as? String ?? ""
                        let value = mainChild.value as? NSDictionary
                        let title = value?["title"] as? String ?? ""
                        let author = value?["author"] as? String ?? ""
                        let category = value?["category"] as? String ?? ""
                        let description = value?["description"] as? String ?? ""
                        let user = value?["uid"] as? String ?? ""
                        
                        print(self.bookkey)

                        self.bookkey.append(key)
                        self.booktitle.append(title)
                        self.bookauthor.append(author)
                        self.bookcategory.append(category)
                        self.bookdescription.append(description)
                        self.bookuser.append(user)
                        let userdata = self.allUsers.childSnapshot(forPath: user).value as? NSDictionary
                        let username = userdata?["name"] as? String ?? ""
                        self.bookusername.append(username)
                        print(username)
                        
                        self.isMyBook.append(false)
                        if(user == userID ?? ""){
                            self.myBookIndex.append(count)
                            self.isMyBook[count] = true
                        }
                        count += 1;
                        
                    }
                    
                    self.showBook()
                })
                
            

                
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func showBook(){
        
        print("in showBook()")
        
        
        self.tableView.reloadData()
        
        print("last showBook()")
    }
    
    /*
    @IBAction func addBookSaveBtn(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        
        
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
    
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isMyBookTapped){
            return myBookIndex.count
        }
        return bookkey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a storage reference from the URL
        let storageReference = Storage.storage().reference()
        let cell  = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
        
        var index = indexPath.row
        if(isMyBookTapped){
            index = myBookIndex[indexPath.row]
        }
            cell.bookTitle.text = booktitle[index]
            cell.bookUser.text = bookusername[index]
            cell.bookCategory.text = bookcategory[index]
            cell.bookAuthor.text = bookauthor[index]
            cell.bookDescription.text = bookdescription[index]
        
            
            
            // Create a reference to the file you want to download
            let bookRef = storageReference.child("Books/\(bookkey[index])")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            bookRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    cell.bookImage.image = UIImage(named: "book-image")
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    
                    cell.bookImage.image = image!
                }
            }
        

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storageReference = Storage.storage().reference()
        let cell = tableView.cellForRow(at: indexPath) as! DemoTableViewCell
        
        
        var index = indexPath.row
        if(isMyBookTapped){
            index = myBookIndex[indexPath.row]
        }
        
        let selectedTrail = booktitle[index]
        print(selectedTrail)
        
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BookDetailsViewController") as! BookDetailsViewController
        
        
        viewController.bookkey = bookkey[index]
        viewController.booktitle = booktitle[index]
        viewController.bookuser = bookuser[index]
        viewController.bookusername = bookusername[index]
        viewController.bookauthor = bookauthor[index]
        viewController.bookdescription = bookdescription[index]
        viewController.bookcategory = bookcategory[index]
        viewController.isMyBook = isMyBook[index]
        viewController.allUsers = allUsers
        viewController.bookimage = cell.bookImage.image
        
        self.present(viewController, animated: true, completion: nil)
        
        /*
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            
            viewController.bookkey = bookkey[index]
            viewController.booktitle = booktitle[index]
            viewController.bookuser = bookuser[index]
            viewController.bookusername = bookusername[index]
            viewController.bookauthor = bookauthor[index]
            viewController.bookdescription = bookdescription[index]
            viewController.bookcategory = bookcategory[index]
            viewController.allUsers = allUsers
            viewController.bookimage = cell.bookImage.image
            
            
            navigationController?.pushViewController(viewController, animated: true)
            
            print("here3")
            
        }
        */
    }

/*
    @objc func showDisplayNameDialog(index: Int)
    {
        let defaults = UserDefaults.standard
        
        let alert = UIAlertController(title: self.booktitle[index], message: self.bookdescription[index], preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                self?.senderDisplayName = textField.text
                
                self?.title = "Chat: \(self!.senderDisplayName!)"
                
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
*/
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
