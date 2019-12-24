//
//  Constants.swift
//  BookShareChat
//
//  Created by cse.repon on 10/27/19.
//  Copyright © 2019 cse.repon. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
