//
//  DySiPost.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

/**
 Determines if author info is to be displayed on device screen or not.
 
 - hidden: Do not show
 - author: Show the author name for author, if exists
 - source: Probably to show the source name for author name, if exists
 */
enum PostBylineType: String {
    case hidden = "Hidden"
    case author = "Author"
    case source = "Source"
}


/**
 Represents a single DySiPost
 */
class DySiPost {
    var author: DySiPostAuthor?
    var title: String?
    var descriptionText: String?
    var createdDateString: String?
    var dictOfImageUrls: [String: Any]?
    var cleanPermaLinkString: String?

    /**
     Initializes a DySiPost
     - Parameter postDict: A dictionary containing properties for the DySiPost
     `postDict` must contain
        - title: `String` representing the title of the post
        - description: `String` representing the description of the post
        - createdDate: `String` representing the date in yyyy-MM-dd'T'HH:mm:ss.SSSSX format
        - cleanPermaLink: `String` representing the permalink of the post
        - postBylineType: `String` representing the hint of how author should be displayed
     choose from `hidden`, `author`, and `source`
        - "author": `[String: Any]` representing the author and source of the post
     */
    init?(postDict: [String: Any]) {
        // get all required properties
        guard let title = postDict["title"] as? String, let cleanPermaLinkString = postDict["cleanPermaLink"] as? String, var authorDict = postDict["author"] as? [String: Any] else {
            // TODO Improvement: Better logging tool than print
            print ("Warning: error parsing api data")
            return nil
        }

        // get image for the post, if exists
        var imageUrlStringDict: [String: Any]?
        if let media = postDict["media"] as? [[String: Any]]  {
            imageUrlStringDict = getDictOfImagesFromMedia(media: media)
        }

        // get info if author information should be shown in byline
        if let postBylineTypeString = postDict["postBylineType"] as? String {
            authorDict["postBylineType"] = postBylineTypeString
        }

        self.author = DySiPostAuthor(authorDict: authorDict)
        self.title = title
        if let descriptionText = postDict["description"] as? String {
            self.descriptionText = !descriptionText.isEmpty ? descriptionText : nil
        }
        if let createdDateString = postDict["createdDate"] as? String {
            self.createdDateString = createdDateString
        }
        self.dictOfImageUrls = imageUrlStringDict
        self.cleanPermaLinkString = cleanPermaLinkString
    }

    /**
     Returns the same string if it can be turned into a Url, else encodes the string to make it turnable to Url
     - Parameter urlString: The string to turn into a string that can turn into Url
     - Returns: A string that can turn into Url
     */
    private func getParsableUrlString(urlString: String) -> String? {
        if URL(string: urlString) != nil {
            return urlString
        } else if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), URL(string: encodedURLString) != nil {
            return encodedURLString
        }
        return nil
    }

    /**
     Gets all the images inside the media dictionary
     - Parameter media: A dictionary that contains array of dictionaries with
     attributes "role" and "url"
     - Returns: A dictionary of images with two keys "original":`String` and "nonoriginals": `[String]`
     */
    private func getDictOfImagesFromMedia(media: [[String: Any]]) -> [String: Any]? {
        var imageUrlStringDict: [String: Any]? = [:]
        var arrayOfImageStrings: [String] = []
        for mediaContent in media {
            if let urlString = mediaContent["url"] as? String, let role = mediaContent["role"] as? String, role.lowercased().contains("image") {
                if let currUrlString = self.getParsableUrlString(urlString: urlString) {
                    if role == Constants.ForDySiAPI.RoleOfCoverImage {
                        imageUrlStringDict?["original"] = currUrlString
                    } else {
                        arrayOfImageStrings.append(currUrlString)
                    }
                }
            }
        }
        imageUrlStringDict?["nonoriginals"] = arrayOfImageStrings
        return imageUrlStringDict
    }
}
