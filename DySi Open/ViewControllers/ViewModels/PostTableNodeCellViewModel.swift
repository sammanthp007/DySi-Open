//
//  PostTableNodeCellViewModel.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/7/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

protocol PostTableNodeCellViewModelProtocol {
    var displayableAuthorName: String? { get }
    var profileImageUrlStringOfAuthor: String? { get }
    var descriptionText: String? { get }
    var displayableTitle: String? { get }
    var displayableDateString: String? { get }
    var coverImageURLString: String? { get }
    var permaLinkUrlString: String { get }
    var sourceSiteString: String? { get }
    var showAuthorInfoInDisplay: Bool { get }
}

/**
 ViewModel to link one DySiPost with PostTableNodeCell
 */
class PostTableNodeCellViewModel: PostTableNodeCellViewModelProtocol {
    /// Owned DySiPost to link with a View
    var post: DySiPost!

    /// To format created date of a post before displaying
    private let dateFormatter = DateFormatter()

    init(post: DySiPost) {
        self.post = post
    }

    /// Name of the author of post to display
    var displayableAuthorName: String? {
        return self.post.author?.author
    }

    /// String representing the url of the Profile picture
    /// of the author of post to display
    var profileImageUrlStringOfAuthor: String? {
        return self.post.author?.profileImageUrlString
    }

    /// Description of post to display
    var descriptionText: String? {
        return self.post.descriptionText
    }

    /// Title of post to display
    var displayableTitle: String? {
        return self.post.title
    }

    /// String representing the created date of post
    var displayableDateString: String? {
        if let dateString = self.post.createdDateString {
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

    /// String representing the url of the cover picture of post
    var coverImageURLString: String? {
        if let imageUrlStringDict = self.post.dictOfImageUrls {
            if let originalImageUrlString = imageUrlStringDict["original"] as? String {
                return originalImageUrlString
            } else if let arrayOfNonOriginalImageUrlString = imageUrlStringDict["nonoriginals"] as? [String], arrayOfNonOriginalImageUrlString.count > 0 {
                return arrayOfNonOriginalImageUrlString[0]
            } else {
                return nil
            }
        }
        return nil
    }

    /// String representing the permalink to open for post
    var permaLinkUrlString: String {
        return self.post.cleanPermaLinkString ?? Constants.SubstitutionTextsInModels.ForPostModel.PermaLinkNotAvailable
    }

    /// Source of post
    var sourceSiteString: String? {
        return self.post.author?.postSourceSiteString
    }

    /// Indication of how to display author info of post
    var showAuthorInfoInDisplay: Bool {
        if self.post.author?.postBylineType == .author {
            return true
        }
        return false
    }
}
