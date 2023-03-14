//
//  User.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit

struct User {
    //var id: UUID
    var name: String?
    //var password: String
    //var bio: String
    
    init(account: CKRecord) {
        self.name = account["name"]
    }
}
