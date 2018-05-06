//
//  DySiPostAuthor.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

class DySiPostAuthor {
    var author: String? // The stored text to display as the author. Notes: Use when the post's postBylineType is "Author".
    var profileImageUrlString: String? // The author's profile picture on the social network
    var providerUserId: String? // The author's ID on the social network; inconsistent: sometimes it seems like string id sometimes its a url
    var providerUserName: String? // The author's name on the social network
    var profileUrlString: String? // The author's profile URL on the social network
    var postSourceName: String? // The name of the source of the post.
    var postSourceSiteString: String? // The website in which the post originated
    var postBylineType: PostBylineType
    
    init?(authorDict: [String: Any]) {
        self.author = authorDict["author"] as? String
        self.profileImageUrlString = authorDict["profileImageUrl"] as? String
        self.providerUserId = authorDict["providerUserId"] as? String
        self.providerUserName = authorDict["providerUserName"] as? String
        self.profileUrlString = authorDict["profileUrl"] as? String
        self.postSourceName = authorDict["postSourceName"] as? String
        self.postSourceSiteString = authorDict["postSourceSite"] as? String
        
        if let postBylineTypeString = authorDict["postBylineType"] as? String {
            self.postBylineType = PostBylineType(rawValue: postBylineTypeString)!
        } else {
            self.postBylineType = .source
        }
    }
    
    func getAuthorDisplayName() -> String? {
        return self.author
    }
    
    func getSourceName() -> String? {
        return self.postSourceName
    }
    
    func getProfileImageUrlString() -> String? {
        return self.profileImageUrlString
    }
    
    func getPostSourceSiteString() -> String? {
        return self.postSourceSiteString ?? nil
    }
    
    func hasAuthor() -> Bool {
        if self.getAuthorDisplayName() != nil && self.postBylineType == .author {
            return true
        }
        return false
    }
}
