//
//  UIOfTableNodeCellComponents.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/7/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import AsyncDisplayKit

extension PostTableNodeCell {
    /**
     Set UI constraints on UIComponents inside the cell.
     - Turn caching on for ImageNodes
     - Set maximum lines for TextNodes
     */
    func setUpUIOfNodes() -> Void {
        self.photoImageNode.shouldRenderProgressImages = true
        self.photoImageNode.shouldCacheImage = true
        self.authorImageNode.shouldRenderProgressImages = true
        self.authorImageNode.shouldCacheImage = true

        self.authorDisplayNameLabel.maximumNumberOfLines = 1
        self.authorDisplayNameLabel.truncationMode = NSLineBreakMode.byTruncatingTail

        self.postTitleLabel.maximumNumberOfLines = 3
        self.postTitleLabel.truncationMode = NSLineBreakMode.byTruncatingTail

        self.postCreatedAtDateLabel.maximumNumberOfLines = 1
        self.postCreatedAtDateLabel.truncationMode = NSLineBreakMode.byTruncatingTail

        self.postDescriptionLabel.maximumNumberOfLines = 14
        self.postDescriptionLabel.truncationMode = NSLineBreakMode.byTruncatingTail

        self.postSourceSiteString.maximumNumberOfLines = 1
        self.postSourceSiteString.truncationMode = NSLineBreakMode.byTruncatingTail
    }

    /**
     Get attributed string for Author.
     - color: Dark Gray
     - Parameter size: Size of the font
     - Parameter authorName: String to associate attributes with
     - Returns: AuthorName string with attributes
     */
    func getAttributedStringForAuthorName(withSize size: CGFloat, authorName: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: authorName, attributes: attr)
    }

    /**
     Get attributed string for Title of a Post.
     - color: Black
     - Parameter size: Size of the font
     - Parameter postTitleString: String to associate attributes with
     - Returns: postTitleString string with attributes
     */
    func getAttributedStringForPostTitle(withSize size: CGFloat, postTitleString: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: postTitleString, attributes: attr)
    }

    /**
     Get attributed string for createdAtDateText.
     - color: Light Gray
     - Parameter size: Size of the font
     - Parameter createdAtDateText: String to associate attributes with
     - Returns: createdAtDateText string with attributes
     */
    func getAttributedStringForCreatedAtDateLabel(withSize size: CGFloat, createdAtDateText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.lightGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: createdAtDateText, attributes: attr)
    }

    /**
     Get attributed string for descriptionText.
     - color: Dark Gray
     - Parameter size: Size of the font
     - Parameter descriptionText: String to associate attributes with
     - Returns: descriptionText string with attributes
     */
    func getAttributedStringForDescription(withSize size: CGFloat, descriptionText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: descriptionText, attributes: attr)
    }

    /**
     Get attributed string for postSourceSiteString.
     - color: Blue
     - Parameter size: Size of the font
     - Parameter postSourceSiteString: String to associate attributes with
     - Returns: postSourceSiteString string with attributes
     */
    func getAttributedStringForSourceSite(withSize size: CGFloat, postSourceSiteString: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.blue,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: postSourceSiteString, attributes: attr)
    }
}
