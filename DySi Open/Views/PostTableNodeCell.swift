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
    let authorDisplayNameLabel = ASTextNode()
    let postCreatedAtDateLabel = ASTextNode()
    let postDescriptionLabel = ASTextNode()
    
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
        // TODO: add attributes to everything
        self.authorDisplayNameLabel.attributedText = self.getAttributedStringForAuthorName(withSize: Constants.CellLayout.FontSize, authorName: postModel.getDisplayableAuthorName())
        self.postDescriptionLabel.attributedText = self.getAttributedStringForDescription(withSize: Constants.CellLayout.FontSize, descriptionText: postModel.getDescriptionText())
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Header Stack
        
        var headerChildren: [ASLayoutElement] = []
        
        let headerStack = ASStackLayoutSpec.horizontal()
        headerStack.alignItems = .center
        authorImageNode.style.preferredSize = CGSize(width: Constants.CellLayout.UserImageHeight, height: Constants.CellLayout.UserImageHeight)
        headerChildren.append(ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForAvatar, child: authorImageNode))
        authorDisplayNameLabel.style.flexShrink = 1.0
        headerChildren.append(authorDisplayNameLabel)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        headerChildren.append(spacer)
        
//        timeIntervalLabel.style.spacingBefore = Constants.CellLayout.HorizontalBuffer
//        headerChildren.append(timeIntervalLabel)
        
        let footerStack = ASStackLayoutSpec.vertical()
        footerStack.spacing = Constants.CellLayout.VerticalBuffer
//        footerStack.children = [photoLikesLabel, photoDescriptionLabel]
        footerStack.children = [postDescriptionLabel]
        headerStack.children = headerChildren
        
        let verticalStack = ASStackLayoutSpec.vertical()
        
        verticalStack.children = [ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForHeader, child: headerStack), ASRatioLayoutSpec(ratio: 1.0, child: photoImageNode), ASInsetLayoutSpec(insets: Constants.CellLayout.InsetForFooter, child: footerStack)]
        
        return verticalStack
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
    
    func getAttributedStringForDescription(withSize size: CGFloat, descriptionText: String) -> NSAttributedString {
        let attr = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: descriptionText, attributes: attr)
    }
}
