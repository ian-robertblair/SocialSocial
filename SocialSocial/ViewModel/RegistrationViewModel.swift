//
//  RegistrationViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit

class RegistrationViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var bio: String = ""
    @Published var picture: String = ""
    
    
    init() {
    }
    
    func registerUser(user: CKRecord?) {
        if let user = user {
            user["name"] = self.userName
            user["bio"] = self.bio
            user["test"] = "test data"
            
        }
    }
}
