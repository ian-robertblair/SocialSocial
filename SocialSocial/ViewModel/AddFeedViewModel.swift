//
//  AddFeedViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/6.
//

import Foundation
import SwiftUI
import PhotosUI
import CloudKit

class AddFeedViewModel:ObservableObject {
    @Published var name:String = ""
    @Published var desc:String = ""
    @Published var picture: PhotosPickerItem?
    @Published var selectedPhoto: Data?
    @Published var disableButton:Bool = false
    
    
    func addFeed(userId: CKRecord, completion: @escaping (Bool) -> Void) {
        CloudKitManager.shared.addFeed(name: name, desc: desc, picture: selectedPhoto, owner: userId) { success in
            if success {
                completion(true)
            }
        }
    }
}
