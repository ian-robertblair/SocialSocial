//
//  Feed.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation
import CloudKit
import UIKit


struct Feed: Identifiable, Equatable, Hashable {
    let id:UUID?
    let name:String?
    let desc:String?
    var pic:UIImage?
    let record: CKRecord?
    let members: Int?
    
    
    init(record: CKRecord?) {
        self.id = UUID()
        self.name = record?["name"]
        self.desc = record?["desc"]
        self.pic = nil
        self.record = record
        self.members = record?["members"]
       
        
        if let picAsset = record?["picture"] as? CKAsset {
            if let url = picAsset.fileURL {
                let data = try? Data(contentsOf: url)
                if let picData = data {
                    self.pic = UIImage(data: picData)
                   
                }
            }
        }
    }
    
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.name == rhs.name
    }
}

/*
 if pic == nil {
             self.pic = UIImage(named: "placeholder")
         } else {
             //TODO: - Download Image
             if let url = thumbnailUrl?.fileURL {
                 let data = try? Data(contentsOf: url)
                 if let data = data {
                     self.thumbnail = UIImage(data: data)
                 }
             }
         }
 */
