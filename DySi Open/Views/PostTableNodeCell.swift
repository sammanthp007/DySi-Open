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
    // separator lines
    let topSeparator    = ASImageNode()
    let bottomSeparator = ASImageNode()

    let authorDisplayNameLabel = ASTextNode()
    let postTitleLabel = ASTextNode()
    let postCreatedAtDateLabel = ASTextNode()
    let postDescriptionLabel = ASTextNode()
    let postSourceSiteString = ASTextNode()

    let authorImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return imageNode
    }()

    let photoImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFit
        imageNode.cropRect = CGRect(x: 0, y: 0, width: 0.0, height: 0.0)
        return imageNode
    }()

    init(postModel: DySiPost) {
        super.init()
        self.selectionStyle = .none
        self.setUpUIOfNodes()

        topSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1.0, cornerColor: .black, fill: .black)
        bottomSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 2.0, cornerColor: .black, fill: .black)

        // get authors displayName if exists
        if let author = postModel.author, author.hasAuthor(), let authorDisplayName = postModel.getDisplayableAuthorName() {
            self.authorDisplayNameLabel.attributedText = self.getAttributedStringForAuthorName(withSize: Constants.CellLayout.TitleFontSize, authorName: authorDisplayName)

            // get author profile image if exists
            if let authorProfileImageURLString = postModel.getProfileImageUrlStringOfAuthor() {
                self.authorImageNode.url = URL(string: authorProfileImageURLString)
            }
        }

        if let coverImageUrlString = postModel.getCoverImageURLString() {
            if let url = URL(string: coverImageUrlString) {
                self.photoImageNode.url = url
            }
        }

        if let postTitleString = postModel.getDisplayableTitle() {
            self.postTitleLabel.attributedText = self.getAttributedStringForPostTitle(withSize: Constants.CellLayout.TitleFontSize, postTitleString: postTitleString)
        }

        if let sourceSiteString = postModel.getSourceSiteString() {
            self.postSourceSiteString.attributedText = self.getAttributedStringForSourceSite(withSize: Constants.CellLayout.MetaDataFontSize, postSourceSiteString: sourceSiteString)
        }

        if let createdAtDateString = postModel.getDisplayableDateString() {
            self.postCreatedAtDateLabel.attributedText = self.getAttributedStringForCreatedAtDateLabel(withSize: Constants.CellLayout.MetaDataFontSize, createdAtDateText: createdAtDateString)
        }

        if let postDescriptionText = postModel.getDescriptionText() {
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

        // Header Stack: contains author info
        var headerChildren: [ASLayoutElement] = []
        let headerStack = ASStackLayoutSpec.horizontal()

        // add author information to header stack if exists
        if self.authorDisplayNameLabel.attributedText != nil {
            headerStack.alignItems = .center

            // add author profile image to header stack if exists
            if authorImageNode.url != nil {
                authorImageNode.style.preferredSize = CGSize(width: Constants.CellLayout.UserImageHeight, height: Constants.CellLayout.UserImageHeight)
                headerChildren.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForAvatar, child: authorImageNode))
            }
            // add author name to header stack
            authorDisplayNameLabel.style.flexShrink = 1.0
            headerChildren.append(authorDisplayNameLabel)

            headerStack.children = headerChildren
        }

        // Add header stack if not empty
        if let headStackContentCount = headerStack.children?.count, headStackContentCount > 0 {
            mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForHeader, child: headerStack))
        }

        // add post image, if exists
        if photoImageNode.url != nil {
            mainVerticalStack.children?.append(ASRatioLayoutSpec(ratio: 2.0/3.0, child: photoImageNode))
        }

        // body stack: contains post title and description
        let bodyStack = ASStackLayoutSpec.vertical()
        bodyStack.children = []
        bodyStack.spacing = Constants.CellLayout.VerticalBuffer
        // add title to stack, if exists
        if postTitleLabel.attributedText != nil {
            bodyStack.children?.append(postTitleLabel)
        }
        // add description to stack, if exists
        if self.postDescriptionLabel.attributedText != nil {
            bodyStack.children?.append(postDescriptionLabel)
        }
        // display stack, if non empty
        if let bodyStackContentCount = bodyStack.children?.count, bodyStackContentCount > 0 {
            if let mainStackCount = mainVerticalStack.children?.count, mainStackCount > 0 {
                mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForBody, child: bodyStack))
            } else {
                mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForBodyWhenNoHeader, child: bodyStack))
            }
        }

        // footer stack: contains metadata
        let footerStack = ASStackLayoutSpec.vertical()
        footerStack.children = []
        footerStack.spacing = Constants.CellLayout.VerticalBuffer

        if postSourceSiteString.attributedText != nil {
            footerStack.children?.append(postSourceSiteString)
        }
        if postCreatedAtDateLabel.attributedText != nil {
            footerStack.children?.append(postCreatedAtDateLabel)
        }
        mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForFooter, child: footerStack))

        mainVerticalStack.children?.append(bottomSeparator)

        return mainVerticalStack
    }
}

extension PostTableNodeCell {
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

    func getAttributedStringForAuthorName(withSize size: CGFloat, authorName: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: authorName, attributes: attr)
    }

    func getAttributedStringForPostTitle(withSize size: CGFloat, postTitleString: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: postTitleString, attributes: attr)
    }

    func getAttributedStringForCreatedAtDateLabel(withSize size: CGFloat, createdAtDateText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.lightGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: createdAtDateText, attributes: attr)
    }

    func getAttributedStringForDescription(withSize size: CGFloat, descriptionText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: descriptionText, attributes: attr)
    }

    func getAttributedStringForSourceSite(withSize size: CGFloat, postSourceSiteString: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.blue,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: postSourceSiteString, attributes: attr)
    }
}
