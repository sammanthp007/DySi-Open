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

class PostTableNodeCellViewModel: PostTableNodeCellViewModelProtocol {
    var post: DySiPost!

    private let dateFormatter = DateFormatter()

    init(post: DySiPost) {
        self.post = post
    }

    var displayableAuthorName: String? {
        return self.post.author?.author
    }

    var profileImageUrlStringOfAuthor: String? {
        return self.post.author?.profileImageUrlString
    }

    var descriptionText: String? {
        return self.post.descriptionText
    }

    var displayableTitle: String? {
        return self.post.title
    }

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

    var permaLinkUrlString: String {
        return self.post.cleanPermaLinkString ?? Constants.UserFacingErrors.ForPostModel.PermaLinkNotAvailable
    }

    var sourceSiteString: String? {
        return self.post.author?.postSourceSiteString
    }

    var showAuthorInfoInDisplay: Bool {
        if self.post.author?.postBylineType == .author {
            return true
        }
        return false
    }
}
