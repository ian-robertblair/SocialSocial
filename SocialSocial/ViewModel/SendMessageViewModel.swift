//
//  SendMessageViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/6.
//

import Foundation
import CloudKit

class SendMessageViewModel:ObservableObject {
    @Published var text = ""
    @Published var media = ""
    @Published var feeds:[Feed] = [Feed]()
    @Published var selectedFeed:Feed? = nil
    @Published var record: CKRecord?
    
    
    func getRecord(name: String, completion: @escaping (Bool) -> Void) {
        Task {
            if let record = try await CloudKitManager.shared.fetchRecord(username: name) {
                DispatchQueue.main.async {
                    self.record = record
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
                        self.feeds = feeds
                       print(feeds)
                    }
                     
                    
                }
            }
        } //task
    }
    
    func updateFeeds(sucess: Bool, feeds: [Feed]?) {
        if sucess {
            DispatchQueue.main.async {
                if let feeds = feeds {
                    self.feeds = feeds
                }
                
            }
        }
    }
    
}
