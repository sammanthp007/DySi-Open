//
//  PostTableNodeCell.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class PostTableNodeCell: ASCellNode {
    /// Image of a black line extending the width of the screen used for separating two cells
    let bottomSeparator = ASImageNode()

    /// Label for name of the Author for post
    let authorDisplayNameLabel = ASTextNode()
    /// Label for title of post
    let postTitleLabel = ASTextNode()
    /// Label for the string representing the date of creation of post
    let postCreatedAtDateLabel = ASTextNode()
    /// Label for description of post
    let postDescriptionLabel = ASTextNode()
    /// Label for source of post
    let postSourceSiteString = ASTextNode()
    /// Node for profile picture of author of post
    let authorImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return imageNode
    }()
    /// Node for cover image of post
    let photoImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFit
        imageNode.cropRect = CGRect(x: 0, y: 0, width: 0.0, height: 0.0)
        return imageNode
    }()

    init(postCellViewModel: PostTableNodeCellViewModelProtocol) {
        super.init()
        self.selectionStyle = .none
        self.setUpUIOfNodes()

        bottomSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 2.0, cornerColor: .black, fill: .black)

        // get authors displayName, if exists and hinted by API to show
        if postCellViewModel.showAuthorInfoInDisplay, let authorDisplayName = postCellViewModel.displayableAuthorName {
            self.authorDisplayNameLabel.attributedText = self.getAttributedStringForAuthorName(withSize: Constants.CellLayout.TitleFontSize, authorName: authorDisplayName)

            // get author profile image
            if let authorProfileImageURLString = postCellViewModel.profileImageUrlStringOfAuthor {
                self.authorImageNode.url = URL(string: authorProfileImageURLString)
            }
        }
        // get cover image
        if let coverImageUrlString = postCellViewModel.coverImageURLString {
            if let url = URL(string: coverImageUrlString) {
                self.photoImageNode.url = url
            }
        }
        // get title of post
        if let postTitleString = postCellViewModel.displayableTitle {
            self.postTitleLabel.attributedText = self.getAttributedStringForPostTitle(withSize: Constants.CellLayout.TitleFontSize, postTitleString: postTitleString)
        }
        // get source of post
        if let sourceSiteString = postCellViewModel.sourceSiteString {
            self.postSourceSiteString.attributedText = self.getAttributedStringForSourceSite(withSize: Constants.CellLayout.MetaDataFontSize, postSourceSiteString: sourceSiteString)
        }
        // get created date of post
        if let createdAtDateString = postCellViewModel.displayableDateString {
            self.postCreatedAtDateLabel.attributedText = self.getAttributedStringForCreatedAtDateLabel(withSize: Constants.CellLayout.MetaDataFontSize, createdAtDateText: createdAtDateString)
        }
        // get description of post
        if let postDescriptionText = postCellViewModel.descriptionText {
            self.postDescriptionLabel.attributedText = self.getAttributedStringForDescription(withSize: Constants.CellLayout.BodyFontSize, descriptionText: postDescriptionText)
        }

        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // initialize the mainVerticalStack
        let mainVerticalStack = ASStackLayoutSpec.vertical()
        mainVerticalStack.spacing = 10
        mainVerticalStack.justifyContent = .center

        mainVerticalStack.children = []

        // set up header Stack: contains author info
        var headerChildren: [ASLayoutElement] = []
        let headerStack = ASStackLayoutSpec.horizontal()

        if self.authorDisplayNameLabel.attributedText != nil {
            headerStack.alignItems = .center

            // add author profile image
            if authorImageNode.url != nil {
                authorImageNode.style.preferredSize = CGSize(width: Constants.CellLayout.UserImageHeight, height: Constants.CellLayout.UserImageHeight)
                headerChildren.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForAvatar, child: authorImageNode))
            }
            // add author name to header stack
            authorDisplayNameLabel.style.flexShrink = 1.0
            headerChildren.append(authorDisplayNameLabel)

            headerStack.children = headerChildren
        }

        // add header stack to main stack
        if let headStackContentCount = headerStack.children?.count, headStackContentCount > 0 {
            mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForHeader, child: headerStack))
        }

        // add post image to main stack
        if photoImageNode.url != nil {
            mainVerticalStack.children?.append(ASRatioLayoutSpec(ratio: 2.0/3.0, child: photoImageNode))
        }

        // setup body stack: contains post texts
        let bodyStack = ASStackLayoutSpec.vertical()
        bodyStack.children = []
        bodyStack.spacing = Constants.CellLayout.VerticalBuffer

        // add title
        if postTitleLabel.attributedText != nil {
            bodyStack.children?.append(postTitleLabel)
        }
        // add description
        if self.postDescriptionLabel.attributedText != nil {
            bodyStack.children?.append(postDescriptionLabel)
        }
        // add body stack to main stack
        if let bodyStackContentCount = bodyStack.children?.count, bodyStackContentCount > 0 {
            if let mainStackCount = mainVerticalStack.children?.count, mainStackCount > 0 {
                mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForBody, child: bodyStack))
            } else {
                mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForBodyWhenNoHeader, child: bodyStack))
            }
        }

        // setup footer stack: contains metadata of post
        let footerStack = ASStackLayoutSpec.vertical()
        footerStack.children = []
        footerStack.spacing = Constants.CellLayout.VerticalBuffer

        // add source
        if postSourceSiteString.attributedText != nil {
            footerStack.children?.append(postSourceSiteString)
        }

        // add creation date
        if postCreatedAtDateLabel.attributedText != nil {
            footerStack.children?.append(postCreatedAtDateLabel)
        }

        // add footer stack to main stack
        mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForFooter, child: footerStack))

        mainVerticalStack.children?.append(bottomSeparator)
        return mainVerticalStack
    }
}
