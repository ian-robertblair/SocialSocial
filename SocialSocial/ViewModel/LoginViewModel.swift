//
//  LoginViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit
import SwiftUI
import UIKit

enum ConnectionStatus {
    case checking
    case connected
    case unregistered
    case fail
}

class LoginViewModel: ObservableObject {
    @Published var message: String = "Checking connection to iCloud..."
    @Published var message2: String = ""
    //@Published var status:String = "Checking"
    @Published var status:ConnectionStatus = .checking
    @Published var retry:Bool = false
    @Published var userRecord: CKRecord?
    @Published var bio: String?
    @Published var image:Image?
   
    
    
    init() {}
    
    func checkICloud() {
        CloudKitManager.shared.checkIcloud { result in
            if result == "available" {
                DispatchQueue.main.async {
                    self.message = "Connected"
                }
            } else {
                print("There was a problem --- \(result ?? "")")
                DispatchQueue.main.async {
                    self.message = "iCloud Failed: \(result ?? "")"
                    self.retry.toggle()
                }
                
            }
        }
    }
    
    func getAccount() {
        CloudKitManager.shared.fetchUserRecordID { recordId in
            Task {
                if let record = try await CloudKitManager.shared.getRecordById(recordId: recordId) {
                    DispatchQueue.main.async { [self] in
                    self.userRecord = record
                    if let name = record["userName"] {
                        
                        self.message2 = "Welcome back, \(name)"
                        self.status = .connected
                    } else {
                        self.status = .unregistered
                    }
                    if let bio = record["bio"] as? String {
                            self.bio = bio
                        }
                    if let imageAsset = record["picture"] as? CKAsset {
                            self.image = getPic(pic: imageAsset)
                        }
                        
                    }//Dispatch
                }
            }
        }
    }
    
    func getPic(pic: CKAsset?) -> Image? {
        if pic == nil {
            return nil
        } else {
            if let url = pic?.fileURL {
                let data = try? Data(contentsOf: url)
                if let data = data, let uiimage = UIImage(data: data) {
                    let image = Image(uiImage: uiimage)
                    return image
                }
            }
        }
       
        return nil
    
    }
}
