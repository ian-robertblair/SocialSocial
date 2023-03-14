//
//  iCloudManager.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit
import UIKit

class CloudKitManager {
    static let shared = CloudKitManager()
    let ckRecordZoneID = CKRecordZone(zoneName: "_defaultZone")
    let container = CKContainer(identifier: "iCloud.iOS-Dev.SocialSocial")
    let publicDatabase = CKContainer(identifier: "iCloud.iOS-Dev.SocialSocial").publicCloudDatabase
    var currentUserID:CKRecord.ID? = nil
    var currentUser: CKUserIdentity? = nil
    
    private init() {
        
    }
    
    func checkIcloud(completion: @escaping (String?) -> Void) {
        container.accountStatus { status, error in
            /*
            if let error = error {
                print("Error getting status: --- \(error)")
                completion(nil)
                return
            }
            */
            
            guard error == nil else {
                print("Error getting status: --- \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            switch status {
            case .available:
                completion("available")
            case .couldNotDetermine:
                completion("could not determine")
            case .noAccount:
                completion("no account")
            case .restricted:
                completion("restricted")
            case .temporarilyUnavailable:
                completion("temporarily unavailable")
            default:
                completion("unkonwn")
            }
        }
    }
    
    func updateUser(record: CKRecord) {
        publicDatabase.save(record) { record, error in
            if let error = error {
                print("Error saving database \(error).")
            }
        }
    }
    
    func login(name: String, password: String) -> Bool {
        return true
    }
    
    func addFeed(name: String, desc: String, picture: Data?, owner: CKRecord?, completion: @escaping (Bool) -> Void) {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("picture.jpg") else {
            return
        }
        
        let feed = CKRecord(recordType: "Feed")
        feed["name"] = name
        feed["desc"] = desc
        feed["id"] = UUID().uuidString
        feed["members"] = 1
        if let owner = owner {
            feed["owner"] = CKRecord.Reference(record: owner, action: .none)
        }
        
        var pictureResized = UIImage()
        
        //resize photo
        if let picture = picture, let pictureOriginal = UIImage(data: picture) {
            pictureResized = ImageResizer(image: pictureOriginal, max: 512)
        }
        
        
        
        if let resizedData = pictureResized.jpegData(compressionQuality: 1) {
            do {
                try resizedData.write(to: url)
                feed["picture"] = CKAsset(fileURL: url)
                print(picture.debugDescription)
                publicDatabase.save(feed) { record, error in
                    if let error = error {
                        print("Error saving database \(error).")
                    }
                    print("Feed Saved... \(record.debugDescription)")    //Debug Description
                    self.addMembership(feed: record, user: owner) { success in
                        if success {
                            completion(true)
                        }
                    }
                    
                    
                }
            } catch {
                print("Error writing picture to disk --- \(error)")
            }
        }
        
        
        
    }
    
    func addMembership(feed: CKRecord?, user: CKRecord?, completion: @escaping (Bool) -> Void) {
        
        if let feed = feed, let user = user {
            let membership = CKRecord(recordType: "membership")
            membership["feed"] = CKRecord.Reference(recordID: feed.recordID, action: .none)
            membership["person"] = CKRecord.Reference(recordID: user.recordID, action: .none)
            
            publicDatabase.save(membership) { _, error in
                if let error = error {
                    print("Error saving membership \(error).")
                }
            }
        }
        
    }
    
    func getRecordById(recordId: CKRecord.ID) async throws -> CKRecord? {
        let record =   try await publicDatabase.record(for: recordId)
        return record
    }
    
    
   
    func getMemberships(record: CKRecord) async throws -> [Feed]? {
        
        var returnedRecords:[CKRecord] = []
        var feeds:[Feed] = []
        
        //Get all user memberships
        let membershipPredicate = NSPredicate(format: "person = %@", record.recordID)
        let query = CKQuery(recordType: "Membership", predicate: membershipPredicate)
        
        let (records, _) = try await publicDatabase.records(matching: query)
        returnedRecords = records.compactMap { _, result in try? result.get() }
        
        //For each of the memberships get the feed, add them to feeds, and return them
        for membership in returnedRecords {
            if let feedId = membership["feed"] as? CKRecord.Reference {
               
                if let feedRecord = try await getRecordById(recordId: feedId.recordID) {
                    let feed = Feed(record: feedRecord)
                    feeds.append(feed)
                }
            }
        }
                
        return feeds
    }
  
    
    func deleteFeed(id: UUID) {
        
    }
    
    func getPosts(feeds: [Feed]) async throws -> [Post]? {
        //TODO: - Add date to the predicate
        var feedRecords = [CKRecord]()
        var postRecords = [CKRecord]()
        var posts = [Post]()
        
        //Add CKRecords to array of feedRecords
        for feed in feeds {
            if let record = feed.record {
                feedRecords.append(record)
            }
        }
        
        //Query all posts from feeds in FeedRecords
        let postPredicate = NSPredicate(format: "feed IN %@", feedRecords)
        let query = CKQuery(recordType: "Post", predicate: postPredicate)
        let (records, _) = try await publicDatabase.records(matching: query)
       
        postRecords = records.compactMap { _, result in try? result.get() }
       
        for post in postRecords {
            posts.append(Post(post: post))
        }
        
        //posts = postRecords.map( {Post(post: $0)} )
        
        return posts
    }
    
    func addPost(feed: UUID, text: String, media: Data?, Mediatype: String) {
        
    }
    
    func deletePost(poast: UUID) {
        
    }
    
    func fetchRecord(username: String) async throws -> CKRecord? {
        var users:[CKRecord] = []
        
        let usersPredicate = NSPredicate(format: "userName = %@", username)
        //let usersPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "users", predicate: usersPredicate)
        
        let (records, _) = try await publicDatabase.records(matching: query)
        users = records.compactMap { _, result in try? result.get() }
        
        if users.count > 0 {
            return users.first
        }
        
        return nil
    }
    
    func fetchUserRecordID(completion: @escaping (CKRecord.ID) -> Void) {
        container.fetchUserRecordID { recordId, error in
            if let error = error {
                print("Fetch User Record failed --- \(error)")
            }
            
            if let recordId = recordId {
                DispatchQueue.main.async {
                    completion(recordId)
                }
            }
        }
    }
    
    
    func fetchUserIdentity() {
        if let currentUserID = currentUserID {
            container.discoverUserIdentity(withUserRecordID: currentUserID) { userRecord, error in
                if let error = error {
                    print("Fetch User Identity failed --- \(error)")
                }
                
                if let userRecord = userRecord {
                    self.currentUser = userRecord
                }
            }
        }
    }
    
    func likePost(post: CKRecord.ID, completion: @escaping (CKRecord?) -> Void) {
        
        publicDatabase.fetch(withRecordID: post) { record, error in
            if let error = error {
                print("Error getting likes: --- \(error)")
            }
            
            if let likes = record?["likes"] as? Int {
                let newlikes = likes + 1
                record?["likes"] = newlikes
                
                if let record = record {
                    self.publicDatabase.save(record) { record, error in
                        if let error = error {
                            print("Error getting likes: --- \(error)")
                        }
                        
                        if let record = record {
                            completion(record)
                        }
                    }
                }
            } else {
                completion(nil)
            }
            
        }
    }
    
    func unlikePost(post: CKRecord.ID, completion: @escaping (CKRecord?) -> Void) {
        
        publicDatabase.fetch(withRecordID: post) { record, error in
            if let error = error {
                print("Error getting likes: --- \(error)")
            }
            
            if let likes = record?["likes"] as? Int {
                let newlikes = likes - 1
                record?["likes"] = newlikes
                
                if let record = record {
                    self.publicDatabase.save(record) { record, error in
                        if let error = error {
                            print("Error getting likes: --- \(error)")
                        }
                        
                        if let record = record {
                            completion(record)
                        }
                    }
                }
            } else {
                completion(nil)
            }
            
        }
    }
    
    func addToLiked(record: CKRecord, post: String) {
        if var listOfLikes = record["liked"] as? [String] {
            listOfLikes.append(post)
            record["liked"] = listOfLikes
            publicDatabase.save(record) { _, error in
                if let error = error {
                    print("Problem adding to likes ---- \(error)")
                }
            }
        }
    }
    
    func removeFromLiked(record: CKRecord, post: String) {
        if var listOfLikes = record["liked"] as? [String] {
            listOfLikes.removeAll(where: {$0 == post})
            record["liked"] = listOfLikes
            publicDatabase.save(record) { _, error in
                if let error = error {
                    print("Problem removing from likes ---- \(error)")
                }
            }
        }
    }
    
}
