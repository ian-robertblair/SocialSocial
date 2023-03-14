//
//  MembershipsViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit

class MembershipsViewModel:ObservableObject {
    @Published var feeds:[Feed] = [Feed]()
    @Published var searchText:String = ""
    @Published var createFeed:Bool = false
    @Published var record:CKRecord? = nil

    func getRecord(name: String, completion: @escaping (Bool) -> Void) {
        Task {
            if let record = try await CloudKitManager.shared.fetchRecord(username: name) {
                DispatchQueue.main.async {
                    self.record = record
                    print(self.record.debugDescription)
                    completion(true)
                }
            }
        }
    }

    func getMemberships() {
        Task {
           
            if let personRecord = self.record {
                if let feeds = try await CloudKitManager.shared.getMemberships(record: personRecord) {
                    DispatchQueue.main.async {
                        for feed in feeds {
                            if !self.feeds.contains(feed) {
                                self.feeds.append(feed)
                            }
                        }
                    }
                }
            }
        }//task
    }
    
}
