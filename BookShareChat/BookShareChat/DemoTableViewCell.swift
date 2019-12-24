//
//  DemoTableViewCell.swift
//  BookShareChat
//
//  Created by cse.repon on 12/3/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import UIKit

class DemoTableViewCell: UITableViewCell {

    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var bookUser: UILabel!
    
    @IBOutlet var bookCategory: UILabel!
    @IBOutlet var bookAuthor: UILabel!
    
    
    
    @IBOutlet var bookDescription: UILabel!
    @IBOutlet var bookImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        print("")
    }
    
}
