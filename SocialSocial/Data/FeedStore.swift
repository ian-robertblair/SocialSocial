//
//  FeedStore.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import Foundation

import Foundation

class FeedStore: ObservableObject {
    var lastPull: Date = Date.now
    var posts: [Post] = [Post]()
    
    init() {
        
    }
}
