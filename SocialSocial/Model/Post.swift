//
//  Post.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit
import UIKit
import SwiftUI

//TODO - make post equatibale 
struct Post: Identifiable, Equatable {
    let id:UUID?
    let date: Date?
    let text: String?
    let audio: String?
    var image: Image
    let author: CKRecord?
    let parent: CKRecord?
    let postRecord:CKRecord?
    var hasPhoto:Bool
    var feedName: String?
    var authorName: String?
    var authorImage: Image?
    var likes: Int?
   
    init(post: CKRecord) {
        self.postRecord = post
        self.date = post["date"]
        self.text =  post["text"]
        self.feedName = nil
        self.author = nil
        self.parent = nil
        self.audio = nil
        self.image = Image(systemName: "photo")
        if let uuidString = post["id"] as? String {
            if let uuid = UUID(uuidString: uuidString) {
                self.id = uuid
            } else {
                self.id = nil
            }
        } else {
            self.id = nil
        }
        self.hasPhoto = false
        self.authorName = nil
        self.authorImage = nil
        self.likes = post["likes"] as? Int
        
        if let picAsset = post["media"] as? CKAsset {
            self.hasPhoto = true
            if let url = picAsset.fileURL {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    let uiimage = UIImage(data: data)
                    if let uiimage = uiimage {
                      
                        image = Image(uiImage: uiimage)
                    }
                }
            }
        }
    }//Init
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.text == rhs.text
    }
  
}

//Post(id, date, text, asset, author, parent)

