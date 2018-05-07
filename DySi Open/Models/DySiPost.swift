//
//  DySiPost.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

enum PostBylineType: String {
    case hidden = "Hidden"
    case author = "Author"
    case source = "Source"
}

class DySiPost {
    var author: DySiPostAuthor?
    var title: String?
    var descriptionText: String?
    var createdDateString: String?
    // TODO: change to list of images and choose the best one for the purpose accordingly, or store all links and provide accordingly
    var listOfImageUrlStrings: [String]?
    var cleanPermaLinkString: String?
    
    private let dateFormatter = DateFormatter()
    
    init?(postDict: [String: Any]) {
        // get all required properties
        guard let title = postDict["title"] as? String, let descriptionText = postDict["description"] as? String, let createdDateString = postDict["createdDate"] as? String, let cleanPermaLinkString = postDict["cleanPermaLink"] as? String, let postBylineTypeString = postDict["postBylineType"] as? String, var authorDict = postDict["author"] as? [String: Any] else {
            // TODO: Handle this error in a safer way
            print ("error parsing api data")
            return
        }
        
        // TODO: handle for external displayMode (check api documentation)
        
        // get the first image
        var listOfUrlStrings: [String]? = []
        if let media = postDict["media"] as? [[String: Any]]  {
            for mediaContent in media {
                if let urlString = mediaContent["url"] as? String, let role = mediaContent["role"] as? String, role.lowercased().contains("image") {
                    listOfUrlStrings?.append(urlString)
                }
            }
        }
        
        // get info if author information should be shown in byline
        authorDict["postBylineType"] = postBylineTypeString
        
        self.author = DySiPostAuthor(authorDict: authorDict)
        self.title = title
        self.descriptionText = descriptionText
        self.createdDateString = createdDateString
        self.listOfImageUrlStrings = listOfUrlStrings
        self.cleanPermaLinkString = cleanPermaLinkString
    }
    
    func getDisplayableAuthorName() -> String? {
        return self.author?.getAuthorDisplayName()
    }
    
    func getProfileImageUrlStringOfAuthor() -> String? {
        return self.author?.getProfileImageUrlString()
    }
    
    func getDescriptionText() -> String? {
        return self.descriptionText
    }
    
    func getDisplayableTitle() -> String {
        return self.title ?? Constants.UserFacingErrors.ForPostModel.TitleNotAvailable
    }
    
    func getCreatedDateAsDate() -> Date {
        // TODO:
        return Date()
    }
    
    func getDisplayableDateString() -> String? {
        if let dateString = self.createdDateString {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSX"
            let date = dateFormatter.date(from: dateString)
            
            guard let createdDate = date else {
                return nil
            }
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: createdDate)
        }
        return nil
    }
    
    func getCoverImageURLString() -> String? {
        if let countOfUrlStrings = self.listOfImageUrlStrings?.count, countOfUrlStrings > 0 {
            return self.listOfImageUrlStrings?[0]
        }
        return nil
    }
    
    func getListOfImageUrlString() -> [String]? {
        return self.listOfImageUrlStrings
    }
    
    func getPermaLinkUrlString() -> String {
        // TODO
        return self.cleanPermaLinkString ?? Constants.UserFacingErrors.ForPostModel.PermaLinkNotAvailable
    }
    
    func getSourceSiteString() -> String? {
        return self.author?.getPostSourceSiteString()
    }
}
