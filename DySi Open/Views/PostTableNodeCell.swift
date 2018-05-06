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
        imageNode.contentMode = .scaleAspectFill
        return imageNode
    }()
    
    init(postModel: DySiPost) {
        super.init()
        
        topSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1.0, cornerColor: .black, fill: .black)
        bottomSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1.0, cornerColor: .black, fill: .black)
        
        if let authorDisplayName = postModel.getDisplayableAuthorName() {
            self.authorDisplayNameLabel.attributedText = self.getAttributedStringForAuthorName(withSize: Constants.CellLayout.FontSize, authorName: authorDisplayName)
        }
        
        self.postTitleLabel.attributedText = self.getAttributedStringForPostTitle(withSize: Constants.CellLayout.FontSize, postTitleString: postModel.getDisplayableTitle())
        
        if let postDescriptionText = postModel.getDescriptionText() {
            self.postDescriptionLabel.attributedText = self.getAttributedStringForDescription(withSize: Constants.CellLayout.FontSize, descriptionText: postDescriptionText)
        }
        
        if let sourceSiteString = postModel.getSourceSiteString() {
            self.postSourceSiteString.attributedText = self.getAttributedStringForSourceSite(withSize: Constants.CellLayout.FontSize, postSourceSiteString: sourceSiteString)
        }
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Header Stack
        var headerChildren: [ASLayoutElement] = []
        let headerStack = ASStackLayoutSpec.horizontal()
        
        if self.authorDisplayNameLabel.attributedText != nil {
            headerStack.alignItems = .center
            authorImageNode.style.preferredSize = CGSize(width: Constants.CellLayout.UserImageHeight, height: Constants.CellLayout.UserImageHeight)
            headerChildren.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForAvatar, child: authorImageNode))
            authorDisplayNameLabel.style.flexShrink = 1.0
            headerChildren.append(authorDisplayNameLabel)
            
            let spacer = ASLayoutSpec()
            spacer.style.flexGrow = 1.0
            headerChildren.append(spacer)
            
            headerStack.children = headerChildren
        }
        
        let bodyStack = ASStackLayoutSpec.vertical()
        bodyStack.spacing = Constants.CellLayout.VerticalBuffer
        bodyStack.children = [postTitleLabel, postSourceSiteString]
        
        //        timeIntervalLabel.style.spacingBefore = Constants.CellLayout.HorizontalBuffer
        //        headerChildren.append(timeIntervalLabel)
        
        let footerStack = ASStackLayoutSpec.vertical()
        if self.postDescriptionLabel.attributedText != nil {
            footerStack.spacing = Constants.CellLayout.VerticalBuffer
            footerStack.children = [postDescriptionLabel]
        }

        let mainVerticalStack = ASStackLayoutSpec.vertical()
        mainVerticalStack.spacing = 20
        mainVerticalStack.justifyContent = .center
        
        
        mainVerticalStack.children = [ASRatioLayoutSpec(ratio: 1.0, child: photoImageNode)]
        
        if let headStackContentCount = headerStack.children?.count, headStackContentCount > 0 {
            mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForHeader, child: headerStack))
        }
        
        mainVerticalStack.children?.append(bodyStack)
        
        if let footerStackContentCount = footerStack.children?.count, footerStackContentCount > 0 {
            mainVerticalStack.children?.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForFooter, child: footerStack))
        }
        
        return mainVerticalStack
    }
}

extension PostTableNodeCell {
    func getAttributedStringForAuthorName(withSize size: CGFloat, authorName: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: authorName, attributes: attr)
    }
    
    func getAttributedStringForPostTitle(withSize size: CGFloat, postTitleString: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: postTitleString, attributes: attr)
    }
    
    func getAttributedStringForCreatedAtDateLabel(withSize size: CGFloat, createdAtDateText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
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
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: postSourceSiteString, attributes: attr)
    }
}
