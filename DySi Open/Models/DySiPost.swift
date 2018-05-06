//
//  DySiPost.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

class DySiPost {
    var author: DySiPostAuthor?
    var title: String?
    var descriptionText: String?
    var createdDateString: String?
    // TODO: change to list of images and choose the best one for the purpose accordingly, or store all links and provide accordingly
    var imageUrlString: String?
    var cleanPermaLinkString: String?
    
    init?(postDict: [String: Any]) {
        // get all required properties
        guard let title = postDict["title"] as? String, let descriptionText = postDict["description"] as? String, let createdDateString = postDict["createdDate"] as? String, let cleanPermaLinkString = postDict["cleanPermaLink"] as? String, let authorDict = postDict["author"] as? [String: Any] else {
            // TODO: Handle this error in a safer way
            print ("error parsing api data")
            return
        }
        
        guard let images = postDict["images"] as? [String: Any], let originalImage = images["Original"] as? [String: Any], let imageUrl = originalImage["url"] as? String else {
            // TODO: Handle this error in a safer way
            print ("error parsing images")
            return
        }
        
        self.author = DySiPostAuthor(authorDict: authorDict)
        self.title = title
        self.descriptionText = descriptionText
        self.createdDateString = createdDateString
        self.imageUrlString = imageUrl
        self.cleanPermaLinkString = cleanPermaLinkString
    }
    
    func getDescriptionText() -> String {
        return self.descriptionText ?? "No description available"
    }
    
    func getDisplayableTitle() -> String {
        return self.title ?? "No title available"
    }
    
    func getCreatedDateAsDate() -> Date {
        // TODO:
        return Date()
    }
    
    func getDisplayableDateString() -> String {
        // TODO:
        return self.createdDateString ?? "18 May 2018"
    }
    
    func getCoverImageURLString() -> String {
        // TODO
        return self.imageUrlString ?? "No image available"
    }
    
    func getPermaLinkUrlString() -> String {
        // TODO
        return self.cleanPermaLinkString ?? "No link available"
    }
}
