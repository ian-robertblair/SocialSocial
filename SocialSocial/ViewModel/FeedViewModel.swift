//
//  FeedViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit
import UIKit
import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var lastPull: Date = Date.now
    @Published var posts:[Post] = [Post]()
    @Published var feeds:[Feed] = [Feed]()
    @Published var sendMessage:Bool = false
    var tempPosts:[Post] = []
    var tempPosts2:[Post] = []
    var tempPosts3:[Post] = []
    
    func getAllPosts(completion: @escaping(Bool) -> Void) {
        Task {
                if let posts = try await CloudKitManager.shared.getPosts(feeds: self.feeds) {
                    DispatchQueue.main.async {
                        self.tempPosts = posts
                        self.tempPosts.sort(by: {$0.date ?? Date.now < $1.date ?? Date.now  } )
                        completion(true)
                    }
                }
           
        }//task
    }
    
    func getNewPosts() {
        
    }
    
    func getFeedNames(completion: @escaping (Bool) -> Void) {
      
        Task {
        
        for post in tempPosts {
            if let feedReference = post.postRecord?["feed"] as? CKRecord.Reference {
              
                    if let feedRecord =  try await  CloudKitManager.shared.getRecordById(recordId: feedReference.recordID) {
                        var newPost = post
                        newPost.feedName = feedRecord["name"]
                        self.tempPosts2.append(newPost)
                    }
                }
            }
            completion(true)
        }//task
        
    }
   
    func getAuthorName() {
        Task {
        for post in tempPosts2 {
            if let authorReference = post.postRecord?["author"] as? CKRecord.Reference {
               
                    if let authorRecord =  try await  CloudKitManager.shared.getRecordById(recordId: authorReference.recordID) {
                        var newPost = post
                        newPost.authorName = authorRecord["name"]
                        newPost.authorImage = getAuthorPics(pic: authorRecord["picture"])
                        self.tempPosts3.append(newPost)
                        
                        DispatchQueue.main.async {
                            self.updatePosts()
                        }
                    }
                }
            }
            
        }//task
    }
    
    func getAuthorPics(pic: CKAsset?) -> Image? {
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
    
    func updatePosts() {
        for post in self.tempPosts3 {
            if !self.posts.contains(post) {
                self.posts.append(post)
                if let sound = UserDefaults.standard.string(forKey: "alertTone")
                {
                    print("Play sound \(sound)")
                    playSound(sound: sound, type: "mp3")
                } else {
                    playSound(sound: "default2", type: "m4a")
                }
                
            } else {
                print("no new posts")
            }
        }//for post in posts
    }
    
    
    func getMemberships(record: CKRecord?, completion: @escaping (Bool) -> Void) {
        Task {
    
            if let personRecord = record {
                if let feeds = try await CloudKitManager.shared.getMemberships(record: personRecord) {
                    DispatchQueue.main.async {
                        self.feeds = feeds
                        completion(true)
                    }
                }
            }
        } //task
    }
    
    func likePost(recordID: CKRecord.ID) {
        CloudKitManager.shared.likePost(post: recordID) { _ in
            
        }
    }
    
    func unlikePost(recordID: CKRecord.ID) {
        CloudKitManager.shared.unlikePost(post: recordID) { _ in
            
        }
    }
    
    func checkliked(id: String, liked: [String]) -> Bool {
        return liked.contains(id)
        
    }
    
    func addToLiked(record: CKRecord, post: String) {
        CloudKitManager.shared.addToLiked(record: record, post: post)
    }
    
    func removeFromLiked(record: CKRecord, post: String) {
        CloudKitManager.shared.removeFromLiked(record: record, post: post)
    }
}
