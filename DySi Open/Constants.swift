//
//  Constants.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

struct Constants {
    struct UILabels {
        static let AllPostViewNavigationItemTitle: String = "DySi Open"
    }
    struct ForDySiAPI {
        struct URLS {
            static let GetAllPosts: String = "https://www.dysiopen.com/v1/posts/public"
        }
    }
    
    struct UserFacingErrors {
        struct ForPostModel {
            static let NotAvailable: String = "Post not Available"
            static let AuthorNotAvailable: String = "Author not available"
            static let TitleNotAvailable: String = "Title not available"
            static let DescriptionNotAvailable: String = "Description not available"
            static let CreatedDateNotAvailable: String = "Unknown post date"
            static let ImageLinkNotAvailable: String = "Image not available"
            static let PermaLinkNotAvailable: String = "Link not available"
        }
        
        
        struct ForPostAuthorModel {
            static let NameNotAvailable: String = "Author's name not available"
        }
    }
    
    struct CellLayout {
        static let FontSize: CGFloat = 14
        static let HeaderHeight: CGFloat = 50
        static let UserImageHeight: CGFloat = 30
        static let HorizontalBuffer: CGFloat = 10
        static let VerticalBuffer: CGFloat = 5
        static let InsetForAvatar = UIEdgeInsets(top: HorizontalBuffer, left: 0, bottom: HorizontalBuffer, right: HorizontalBuffer)
        static let InsetForHeader = UIEdgeInsets(top: 0, left: HorizontalBuffer, bottom: 0, right: HorizontalBuffer)
        static let InsetForFooter = UIEdgeInsets(top: VerticalBuffer, left: HorizontalBuffer, bottom: VerticalBuffer, right: HorizontalBuffer)
    }
}
